<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");

	String pkIdx = request.getParameter("pkIdx");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>댓글 수정 창</title>
</head>
<body>
<form action="modifyComment_do.jsp" method="GET">
댓글을 수정합니다.<br>
	<input type="hidden" name="pkIdx" value="<%=pkIdx %>">
	<input type="text" name="modifiedComment" placeholder="수정할 내용을 입력해주세요.">
	<input type="submit" value="수정 완료">
</form>
</body>
</html>