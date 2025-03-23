<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="//cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">
    </head>
    <body>
        
        <nav class="navbar navbar-dark bg-primary">
            <h3 style="color: white">Student Management System Crud Using Jsp Ajax</h3>
        </nav>
        
        </br>
        <div class="row">
         
            <div class="col-sm-4">
                <div class="container">
                    
                    <form id="frmStudent" name="frmStudent">
                       
                        <div class="form-group" align="left">
                            <label>Student Name</label>
                            <input type="text" name="stname" id="stname" class="form-control" placeholder="StudentName" size="30px" required>
                        </div>
                        
                        <div class="form-group">
                            <label>Course</label>
                            <input type="text" name="course" id="course" class="form-control" placeholder="Course" size="30px" required>
                        </div>
                        
                         <div class="form-group">
                            <label>Fee</label>
                            <input type="text" name="fee" id="fee" class="form-control" placeholder="Fee" size="30px" required>
                        </div>
                        
                         <div class="form-group" align="right">
                             <button type="button" class="btn btn-info" id="save" onclick="addStudent()">Add</button>
                             <button type="button" class="btn btn-warning" id="reset" onclick="reSet()">Reset</button>
                        </div>  
                    </form>      
                </div>     
            </div>
            
            <div class="col-sm-8">
                
                <div class="panel-body">
                    <table id="tbl-student" class="table table-bordered" cellpadding="0" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                            </tr>   
                        </thead>  
                    </table>  
                </div>
            </div>
        </div>
        
        <script src="component/jquery/jquery.js" type="text/javascript"></script>
        <script src="component/jquery/jquery.min.js" type="text/javascript"></script>
        <script src="component/jquery.validate.min.js" type="text/javascript"></script>
         <script src="//cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js" type="text/javascript"></script>

        <script>
            
            getall();
            var isNew = true;
            var studentid = null;
            
            function addStudent()
            {
                if($("#frmStudent").valid())
                {     
                    var url="";
                    var data= "";
                    var method;

                    if(isNew==true)
                    {
                        
                        url = 'add.jsp';
                        data = $("#frmStudent").serialize();
                        method = 'POST' 
                    }
                    else
                    {
                        
                        url = 'update.jsp';
                        data = $("#frmStudent").serialize() + "&studentid=" + studentid;
                        method = 'POST'

                    }
                    $.ajax({
                        
                        type: method,
                        url : url,
                        dataType: 'JSON',
                        data : data,
                        
                        success:function(data)
                        {
                            getall();
                            
                            $('#stname').val("");
                            $('#course').val("");
                            $('#fee').val("");
                            
                            if(isNew ==true)
                            {
                                alert("Record Adddeddd");
                            }
                            else
                            {
                                 alert("Record Updatee");
                                
                            }
                        }

                    });
  
                }
       
            }

            function getall()
            {
                
                $('#tbl-student').dataTable().fnDestroy();
                $.ajax({
                    
                    url: "all_student.jsp",
                    type : "GET",
                    dataType : "JSON",
                    
                    success:function(data)
                    {
                        
                       $('#tbl-student').dataTable({
                           "aaData":data,
                           "scrollX": true,
                           "aoColumns":
                                   [
                               
                                    {"sTitle": "Student Name","mData": "name"},
                                    {"sTitle": "Course","mData": "course"},
                                    {"sTitle": "Fee","mData": "fee"},
                                    
                                    {
                                        "sTitle": 
                                        "Edit",
                                        "mData": "id",
                                        "render" : function(mData,type,row,meta)
                                        {
                                            return '<button class="btn btn-success" onclick="get_details('+ mData +')">Edit</button>';
                                        }
                                   },
                                    
                               {
                                        "sTitle": 
                                        "Delete",
                                        "mData": "id",
                                        "render" : function(mData,type,row,meta)
                                        {
                                            return '<button class="btn btn-danger" onclick="get_delete('+ mData +')">Delete</button>';
                                        }
                                   },      
                                   ] 
                       }); 
                       
                    }   
                   
                });
                
                
            }

            function get_details(id)
            {
             
                $.ajax({
                    
                    type: "POST",
                    url : "edit_return.jsp",
                    data : {"id": id},
               
                    
                    success: function(data)
                    {
                        isNew = false
                        var obj = JSON.parse(data);
                        studentid = obj[0].id
                        $('#stname').val(obj[0].stname);
                        $('#course').val(obj[0].scourse);
                        $('#fee').val(obj[0].sfee);
                    }
  
                });

            }

            function get_delete(id)
            {
                
                $.ajax({
                    
                    type: 'POST',
                    url: 'delete.jsp',
                    dataType: 'JSON',
                    data:{"id": id},
                    
                    success:function(data)
                    {
                        alert("Record Deletedddd");
                        getall();
                    }            
                });
            }
   
        </script>

    </body>
</html>

//add.jsp

<%@page import="java.sql.DriverManager"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.json.simple.JSONArray"%>
<%  

JSONArray list = new JSONArray();

String studname = request.getParameter("stname");
String course = request.getParameter("course");
String fee = request.getParameter("fee");

Connection con;
PreparedStatement pst;
ResultSet rs;


JSONObject obj = new JSONObject();

Class.forName("com.mysql.jdbc.Driver");
con = DriverManager.getConnection("jdbc:mysql://localhost/jspstudent","root","");
pst = con.prepareStatement("insert into records (stname,course,fee)values(?,?,?)");
pst.setString(1, studname);
pst.setString(2, course);
pst.setString(3, fee);
pst.executeUpdate();
obj.put("name", "success");
list.add(obj);
out.println(list.toJSONString());
out.flush();

%>

//student.jsp

<%@page import="java.sql.Statement"%>
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
//edit.jsp
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.json.simple.JSONArray"%>
//<%@page contentType="text/html" pageEncoding="UTF-8"%>

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

//update

<%
    
JSONArray list = new JSONArray();


String stid = request.getParameter("studentid");
String studname = request.getParameter("stname");
String course = request.getParameter("course");
String fee = request.getParameter("fee");

Connection con;
PreparedStatement pst;
ResultSet rs;


JSONObject obj = new JSONObject();

Class.forName("com.mysql.jdbc.Driver");
con = DriverManager.getConnection("jdbc:mysql://localhost/jspstudent","root","");
pst = con.prepareStatement("update records set stname = ?, course= ? , fee= ? where id = ?");
pst.setString(1, studname);
pst.setString(2, course);
pst.setString(3, fee);
pst.setString(4, stid);
pst.executeUpdate();
obj.put("name", "success");
list.add(obj);
out.println(list.toJSONString());
out.flush();




%>

//delete


<%
JSONArray list = new JSONArray();
String stid = request.getParameter("id");
Connection con;
PreparedStatement pst;
ResultSet rs;
JSONObject obj = new JSONObject();
Class.forName("com.mysql.jdbc.Driver");
con = DriverManager.getConnection("jdbc:mysql://localhost/jspstudent","root","");
pst = con.prepareStatement("delete from records where id = ?");
pst.setString(1, stid);
pst.executeUpdate();
obj.put("name", "success");
list.add(obj);
out.println(list.toJSONString());
out.flush();
%>

