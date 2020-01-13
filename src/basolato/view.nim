import json, random, strformat,  std/sha1, times
import flatdb

proc get*(val:JsonNode):string =
  case val.kind
  of JString:
    return val.getStr
  of JInt:
    return $(val.getInt)
  of JFloat:
    return $(val.getFloat)
  of JBool:
    return $(val.getBool)
  of JNull:
    return ""
  else:
    raise newException(JsonKindError, "val is array")

proc rundStr():string =
  randomize()
  for _ in .. 50:
    add(result, char(rand(int('A')..int('z'))))


proc csrf_token*():string =
  let token = rundStr().secureHash()
  echo token
  # insert db
  var db = newFlatDb("session.db", false)
  discard db.load()
  db.append(%*{
    "token": $token, "generated_at": $(getTime().toUnix())
  })
  return &"""<input type="hidden" name="_token" value="{token}">"""