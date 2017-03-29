<%@ page import="dbbeans.ResumeReviewRequestBean" %>
<%@ page import="dbbeans.UserBean" %>
<%@ page import="java.util.ArrayList" %>
<%--
  Created by IntelliJ IDEA.
  User: timothysmith
  Date: 2017-03-27
  Time: 12:03 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    ArrayList<ResumeReviewRequestBean> resumeList = ResumeReviewRequestBean.getReviewRequests();
    UserBean user = (UserBean) request.getSession().getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("sessionended.jsp");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <link rel="stylesheet" type="text/css" href="../css/modPage.css">
    <link rel="stylesheet" type="text/css" href="../css/bootstrap.css">
    <link rel="stylesheet" href="../css/header.css">
    <link href='http://fonts.googleapis.com/css?family=Cookie' rel='stylesheet' type='text/css'>
    <title>Moderator Panel</title>
    <meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; width=device-width;">
</head>

<body>
<!-- HEADER CODE - DO NOT REMOVE -->
<header class="header-basic">

    <div class="header-limiter">

        <h1><a href="#">COOP<span>Database</span></a></h1>

        <nav>
            <a href="../student/studenthome.jsp">Home</a>
            <a href="../student/profile.jsp">Profile</a>
            <a href="#">Resume</a>
            <a href="../jobs/searchjobs.jsp">Jobs</a>
            <a href="#">Write Review</a>
            <% if (user != null) {
                if (user.isAdmin(user.getUsername())) { %>
            <a href="admin.jsp">Admin Panel</a>
            <% } %>
            <% if (user.isModerator(user.getUsername())) { %>
            <a href="mod.jsp" class="selected">Moderator Panel</a>
            <% }
            }%>
            <a href="../session/goodbye.jsp">Logout</a>
        </nav>
    </div>

</header>
<!-- HEADER CODE - DO NOT REMOVE -->
<div class="table-title">
    <h3>Resumes to be Reviewed</h3>
</div>
<table class="table-fill">
    <thead>
    <tr>
        <th class="text-left">User</th>
        <th class="text-center">Resume</th>
    </tr>
    </thead>
    <tbody class="table-hover">
    <% for (ResumeReviewRequestBean resume : resumeList) { %>
        <tr id="">
            <td class="text-left">
                <%= resume.getRequesterUsername() %>
            </td>
            <td class="text-center">
                <form style="all:initial" action="resume/resumereview.jsp" method="POST">
                    <input type="hidden" name="resumeid" value="<%= resume.getResumeId() %>"/>
                    <button class="btn btn-primary" type="submit">Review</button>
                </form>
            </td>
        </tr>
    <% } %>
    </tbody>
</table>
<hr>

</body>
</html>