 const fio = require("fs")
 const jsonTable  = require("./wxwidgets_in.json")

 var variableTable =  {
 	"PLATFORM_WIN32": "1",
 	"PLATFORM_UNIX": "0",
 	"PLATFORM_MACOSX": "0",
 	"TOOLKIT": "MSW",
 	"TOOLKIT_VERSION": "4",
 	"USE_GUI": "1",
 	"WXUNIV": "0",
	"FORMAT": "aurora",
 	"USE_PLUGINS": "0"
}

function stringifyTableJS()
{
	var translatedScript =  "";
	var keys = Object.keys(variableTable)
	keys.forEach((key) => {
		var value = variableTable[key]
		value = value.split("\r").join("\\r").split("\n").join("\\n")
		translatedScript += "var " + key + " = \"" + value + "\";\n"
	})
	return translatedScript
}

function stringifyTableLua()
{
	var translatedScript =  "";
	var keys = Object.keys(variableTable)
	keys.forEach((key) => {
		var value = variableTable[key]
		//value = value.split("\r").join("");
		if (value.indexOf("\n") != -1)
		{
			var onePassed = false
			translatedScript += "local " + key + " = {\n";
			var subValues = value.split(" ").join("\n").split("\n");
			for (var i = 0; i < subValues.length; i++)
			{
				var subValue = subValues[i].trim();
				if (subValue.length == 0) continue
				translatedScript += "	\"" + subValue.trim() + "\"" + (i + 1 == subValues.length ? "" : ",") + "\n"
			}
			translatedScript += "};\n"
		}
		else
		{
			translatedScript += "local " + key + " = \"" + value + "\";\n"
		}

	})
	return translatedScript
}

function stringifyTableTableLua()
{
	var translatedScript =  "";
	var keys = Object.keys(variableTable)
	translatedScript += "local _MAGICTABLE = {\n";
	for (var i = 0; i < keys.length; i++)
	{
		var key = keys[i];
		translatedScript += "	\"" + key + "\" = " + key + (i + 1 == keys.length ? "" : ",") + "\n"
	}

	translatedScript += "};\n"
	return translatedScript
}

function isGroupValid(json, condition)
{
	var translatedScript =  stringifyTableJS()

	console.log(condition)
	if (condition.indexOf("FORMAT") != -1)
	{
		// global struct should always pass
		return true
	}

	translatedScript += condition.split("and").join("&&");
	
	//console.log("script", translatedScript)
	var val = eval(translatedScript)
	//console.log(translatedScript, val)

	return val
}

function getGroupValid(json)
{
	if (!json.if)
		return json

	var conditions = json.if
	var condition = null
	if (!conditions)
	{
		console.log("json object missing condition array/object", json)
		return false
	}

	if (Array.isArray(conditions))
	{
		for(condition of conditions)
		{
			var condField = condition["@cond"]
			if (!condField)
			{
				console.log("json child object missing condition", condition)
				continue
			}
			if (isGroupValid(json, condField))
			{
				return condition
			}
		}
	} 
	else 
	{
		condition = conditions["@cond"]
		if (!condition)
		{
			console.log("json object missing condition", json)
			return false
		}
		if (isGroupValid(json, condition))
		{
			return conditions
		}
	}
}

function parseString(str)
{
	for(var nextIndex = 0; (nextIndex = str.indexOf("$")) != -1;  ) 
	{
		if (str[nextIndex + 1] != "(")
		{
			console.log("$ is not allowed in string. giving up, returning: ", str)
			return str
		}

		var prefix = str.substr(0, nextIndex);
		var endIndex = str.indexOf(")", nextIndex)
		var expressionStart = nextIndex + 2;luaBuildScript
		var expression = str.substr(expressionStart, endIndex - expressionStart)
		var suffix = str.substr(endIndex + 1)

		console.log("reconstructing", prefix, expression, suffix)
		var value = variableTable[expression]

		if (!value)
		{
			console.log("warning: couldn't lookup variable", expression)
			console.log(expression)
			value = ""
		}

		str = prefix + value + suffix
	}
	console.log("parsed expression", str)
	return str
}

function handleSetVariablesFunc(json, text)
{
	var value = null;
	if (Array.isArray(text))
	{
		text.forEach((line) => {value += parseString(line) + "\\n"}	)
	}
	else
	{
		value = parseString(text)
	}
	console.log("key", json["@var"])
	variableTable[json["@var"]] = value;

}

function handleSetVariableField(json, fields)
{
	console.log("processing set variables")
	fields.forEach(field => processVariable(field))
}

function processVariable(json, override) 
{
	console.log("analyzing", json)

	var key = json
	if (!((override) || (key = getGroupValid(json))))
	{
		console.log("ignoring group")
		return;
	}

	console.log("parsing", key)

	var setVariablesFunc = key["set"]
	var setVariableField = key["#text"]

	if (setVariablesFunc)
	{
		handleSetVariableField(json, setVariablesFunc)
	}
	else if (setVariableField)
	{
		console.log("alpha")
		handleSetVariablesFunc(json, setVariableField)
	}
}

processVariable(jsonTable, true)
console.log("processed")
console.log(variableTable)

var luaBuildScript = stringifyTableLua()
luaBuildScript += "\n\n\n";
luaBuildScript += stringifyTableTableLua()

fio.writeFileSync("out.lua", luaBuildScript)