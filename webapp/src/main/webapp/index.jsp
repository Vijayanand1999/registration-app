<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Student Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="//cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">
</head>
<body>

    <nav class="navbar navbar-dark bg-primary">
        <h3 style="color: white">Student Management System CRUD Using JSP AJAX</h3>
    </nav>

    <br>
    <div class="row">
        <div class="col-sm-4">
            <div class="container">
                <form id="frmStudent" name="frmStudent">
                    <div class="form-group">
                        <label>Student Name</label>
                        <input type="text" name="stname" id="stname" class="form-control" placeholder="Student Name" required>
                    </div>

                    <div class="form-group">
                        <label>Course</label>
                        <input type="text" name="course" id="course" class="form-control" placeholder="Course" required>
                    </div>

                    <div class="form-group">
                        <label>Fee</label>
                        <input type="text" name="fee" id="fee" class="form-control" placeholder="Fee" required>
                    </div>

                    <div class="form-group" align="right">
                        <button type="button" class="btn btn-info" id="save" onclick="addStudent()">Add</button>
                        <button type="button" class="btn btn-warning" id="reset" onclick="resetForm()">Reset</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="col-sm-8">
            <div class="panel-body">
                <table id="tbl-student" class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Student Name</th>
                            <th>Course</th>
                            <th>Fee</th>
                            <th>Edit</th>
                            <th>Delete</th>
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
        var isNew = true;
        var studentId = null;

        $(document).ready(function () {
            getAllStudents();

            $('#frmStudent').validate({
                rules: {
                    stname: "required",
                    course: "required",
                    fee: "required"
                }
            });
        });

        function addStudent() {
            if ($("#frmStudent").valid()) {
                var url = isNew ? '' : '';
                var data = $("#frmStudent").serialize() + (isNew ? '' : '&studentid=' + studentId);
                var method = 'POST';

                $.ajax({
                    type: method,
                    url: 'index.jsp',
                    dataType: 'JSON',
                    data: data,
                    success: function (data) {
                        getAllStudents();
                        resetForm();
                        alert(isNew ? "Record Added" : "Record Updated");
                    }
                });
            }
        }

        function getAllStudents() {
            $('#tbl-student').DataTable().destroy();
            $.ajax({
                url: 'index.jsp',
                type: 'GET',
                dataType: 'JSON',
                success: function (data) {
                    $('#tbl-student').DataTable({
                        data: data,
                        columns: [
                            { "data": "name" },
                            { "data": "course" },
                            { "data": "fee" },
                            {
                                "data": "id",
                                "render": function (data) {
                                    return '<button class="btn btn-success" onclick="editStudent(' + data + ')">Edit</button>';
                                }
                            },
                            {
                                "data": "id",
                                "render": function (data) {
                                    return '<button class="btn btn-danger" onclick="deleteStudent(' + data + ')">Delete</button>';
                                }
                            }
                        ],
                        scrollX: true
                    });
                }
            });
        }

        function editStudent(id) {
            $.ajax({
                type: 'POST',
                url: 'index.jsp',
                data: { id: id },
                success: function (data) {
                    var student = JSON.parse(data)[0];
                    isNew = false;
                    studentId = student.id;
                    $('#stname').val(student.stname);
                    $('#course').val(student.scourse);
                    $('#fee').val(student.sfee);
                }
            });
        }

        function deleteStudent(id) {
            $.ajax({
                type: 'POST',
                url: 'index.jsp',
                dataType: 'JSON',
                data: { deleteId: id },
                success: function () {
                    alert("Record Deleted");
                    getAllStudents();
                }
            });
        }

        function resetForm() {
            $('#stname').val('');
            $('#course').val('');
            $('#fee').val('');
            isNew = true;
            studentId = null;
        }

        // Handle add/update and delete requests (backend logic within this page)
        if (window.location.href.indexOf("index.jsp") > -1) {
            var method = request.getMethod();
            if (method == "POST") {
                var studentname = request.getParameter("stname");
                var course = request.getParameter("course");
                var fee = request.getParameter("fee");
                var studentId = request.getParameter("studentid");
                var deleteId = request.getParameter("deleteId");
                if (studentId) {
                    // Update student
                    updateStudent(studentId, studentname, course, fee);
                } else if (deleteId) {
                    // Delete student
                    deleteStudentFromDb(deleteId);
                } else {
                    // Add new student
                    addStudentToDb(studentname, course, fee);
                }
            } else if (method == "GET") {
                // Get all students
                getAllStudentsFromDb();
            }
        }

        function addStudentToDb(studname, course, fee) {
            var conn = null;
            var stmt = null;
            var jsonArray = [];
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/jspstudent", "root", "");
                stmt = conn.prepareStatement("INSERT INTO records (stname, course, fee) VALUES (?, ?, ?)");
                stmt.setString(1, studname);
                stmt.setString(2, course);
                stmt.setString(3, fee);
                stmt.executeUpdate();
                jsonArray.push({ "name": "success" });
                response.setContentType("application/json");
                response.getWriter().write(jsonArray.toJSONString());
            } catch (e) {
                e.printStackTrace();
            } finally {
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (e) {
                    e.printStackTrace();
                }
            }
        }

        function updateStudent(studentId, studname, course, fee) {
            var conn = null;
            var stmt = null;
            var jsonArray = [];
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/jspstudent", "root", "");
                stmt = conn.prepareStatement("UPDATE records SET stname = ?, course = ?, fee = ? WHERE id = ?");
                stmt.setString(1, studname);
                stmt.setString(2, course);
                stmt.setString(3, fee);
                stmt.setString(4, studentId);
                stmt.executeUpdate();
                jsonArray.push({ "name": "success" });
                response.setContentType("application/json");
                response.getWriter().write(jsonArray.toJSONString());
            } catch (e) {
                e.printStackTrace();
            } finally {
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (e) {
                    e.printStackTrace();
                }
            }
        }

        function deleteStudentFromDb(deleteId) {
            var conn = null;
            var stmt = null;
            var jsonArray = [];
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/jspstudent", "root", "");
                stmt = conn.prepareStatement("DELETE FROM records WHERE id = ?");
                stmt.setString(1, deleteId);
                stmt.executeUpdate();
                jsonArray.push({ "name": "success" });
                response.setContentType("application/json");
                response.getWriter().write(jsonArray.toJSONString());
            } catch (e) {
                e.printStackTrace();
            } finally {
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (e) {
                    e.printStackTrace();
                }
            }
        }

        function getAllStudentsFromDb() {
            var jsonArray = [];
            var conn = null;
            var stmt = null;
            var rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/jspstudent", "root", "");
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT * FROM records");

                while (rs.next()) {
                    var student = {
                        "id": rs.getString("id"),
                        "name": rs.getString("stname"),
                        "course": rs.getString("course"),
                        "fee": rs.getString("fee")
                    };
                    jsonArray.push(student);
                }
                response.setContentType("application/json");
                response.getWriter().write(jsonArray.toJSONString());
            } catch (e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (e) {
                    e.printStackTrace();
                }
            }
        }
    </script>
</body>
</html>
