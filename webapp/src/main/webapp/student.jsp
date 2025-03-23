<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%  
JSONArray list = new JSONArray();
Connection con;
PreparedStatement pst;
ResultSet rs;

Class.forName("com.mysql.jdbc.Driver");
con = DriverManager.getConnection("jdbc:mysql://localhost/jspstudent","root","");

String query = "select * from records";

Statement stmt = con.createStatement();

rs = stmt.executeQuery(query);


while(rs.next())
{
    JSONObject obj = new JSONObject();
    String id = rs.getString("id");
    String name = rs.getString("stname");
    String course = rs.getString("course");
    String fee = rs.getString("fee");
    
    obj.put("name", name);
    obj.put("course", course);
    obj.put("fee", fee);
    obj.put("id", id);
    list.add(obj);
}

out.print(list.toJSONString());
out.flush();

%>
