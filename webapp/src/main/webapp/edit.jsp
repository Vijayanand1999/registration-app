<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.DriverManager"%>
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

String id = request.getParameter("id");

pst = con.prepareStatement("select id,stname,course,fee from records where id = ?");

pst.setString(1, id);
rs = pst.executeQuery();

if(rs.next()==true)
{
    String id1 = rs.getString(1);
    String stname = rs.getString(2);
    String scourse = rs.getString(3);
    String sfee = rs.getString(4);
     JSONObject obj = new JSONObject();
     
     obj.put("id",id1);
     obj.put("stname",stname);
     obj.put("scourse",scourse);
     obj.put("sfee",sfee);
     list.add(obj);
     
    
}

out.print(list.toJSONString());
out.flush();




%>
