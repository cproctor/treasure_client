/* 
 These helper functions assist in turning JSON into Processing objects.
 You don't need to worry about them. 
 */
 
IntList json2IntList(JSONArray json) {
   return new IntList(json.getIntArray());
}


IntDict json2IntDict(JSONObject json) {
  IntDict dict = new IntDict();
  StringList keys = new StringList(json.keys());
  for (String k : keys) {
    dict.set(k, json.getInt(k)); 
  }
  return dict;
}
