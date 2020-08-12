<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 출력</title>
<link rel="stylesheet" type="text/css" href="printArticle_css.css">
<link rel="stylesheet" type="text/css" href="outline.css">
</head>
<body>
<%
	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/snsboard?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD= "1234";

	Connection con= null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	String idx = request.getParameter("idx");
	
	try {
		con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		String sql = "UPDATE article SET view=view+1 WHERE idx=?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, idx);
		pstmt.executeUpdate();
		
		sql = "SELECT title, author, mainArticle, fileName, star, time FROM article WHERE idx=?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, idx);
		rs = pstmt.executeQuery();
		rs.next();
%>
<div id="wrap">
	<div id="title">
		<h1><a href="mainPage.jsp">모두의 자유게시판</a></h1>
	</div>	
	<div id="link">
		<a href="wrtieText.jsp">글 등록</a>
	</div>
</div>
<div id="wrap2">
	<div id="side">
	</div>
	<div id="main">
		<div id="image">
			<img src="./upload/<%=rs.getString("fileName") %>" width="100" height="100">
		</div>
		<div id="info">
			제목: <input type="text" name="title" class="result" value="<%=rs.getString("title") %>" readonly><br>
			글쓴이: <input type="text" name="author" class="result" value="<%=rs.getString("author") %>" readonly><br>
			추천 수: <input type="text" name="star" class="result" value="<%=rs.getInt("star") %>" readonly><br>
			작성 시간: <%=rs.getString("time") %>
		</div>
		<div id="mainText">
			<textarea cols="215" rows="40" name="mainText" class="result" readonly><%=rs.getString("mainArticle") %></textarea>
		</div>
		<a href="addStar.jsp?idx=<%=idx %>" style="text-decoration:none; " id="like">이 글 추천하기</a>
		<form action="writeComment_do.jsp?idx=<%=idx %>" method="GET">
			<div id="comment">
				<input type="hidden" name="idx" value="<%=idx %>">
				작성자: <input type="text" id="author" name="author">
				댓글 쓰기 <input type="text" id="mainComment" name="mainComment">
				<input id="submit" type="submit" value="댓글 등록">
			</div>
		</form>
		<%
			sql = "SELECT * FROM comment WHERE idx=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, idx);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
		%>
			<table border="1" style="border-collapse: collapse;" class="comment">
				<tr>
					<td>
					<%=rs.getString("mainComment") %> | 작성자: <%=rs.getString("author") %> | 작성일자: <%=rs.getString("time") %>
					</td>
					<td>
						<a href="modifyComment.jsp?pkIdx=<%=rs.getInt("pkIdx") %>">수정</a>
					</td>
					<td>
						<a href="deleteComment_do.jsp?pkIdx=<%=rs.getInt("pkIdx") %>">삭제</a>
					</td>
				</tr>
			</table>
		<% 
			} 
		%>
	</div>
</div>
<%
		rs.close();
		pstmt.close();
		con.close();
	}catch(SQLException e) {
		out.println(e);
	}
%>
</body>
</html>