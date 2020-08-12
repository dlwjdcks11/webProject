<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");


	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/snsboard?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD= "1234";

	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	PreparedStatement pstmt2 = null;
	ResultSet rs2 = null;
	
	try {
		con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		String sql = "SELECT idx, title FROM article ORDER BY view DESC LIMIT 0, 5";
		pstmt = con.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		sql = "SELECT idx, title FROM article ORDER BY star DESC LIMIT 0, 3";
		pstmt2 = con.prepareStatement(sql);
		rs2 = pstmt2.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 쓰기</title>
<link rel="stylesheet" type="text/css" href="writeText_css.css">
<link rel="stylesheet" type="text/css" href="outline.css">
</head>
<body>
<form action="#" method="post">
<div id="wrap">
	<div id="title">
		<h1><a href="mainPage.jsp">모두의 자유게시판</a></h1>
	</div>	
	<div id="link">
		<a href="wrtieText.jsp">글 등록</a>
	</div>
</div>
</form>
<div id="wrap2">
	<div id="side">
		<div class="sideInfo">
		조회 수 순위
			<ol type="1">
				<%
				while(rs.next()) {
				%>
					<li><a href="printArticle.jsp?idx=<%=rs.getInt("idx") %>"><%=rs.getString("title") %></a></li>
				<%
					}
				%>
			</ol>
		</div>
		<div class="sideInfo">
		추천 수 순위
			<ol type="1">
				<%
				while(rs2.next()) {
				%>
					<li><a href="printArticle.jsp?idx=<%=rs2.getInt("idx") %>"><%=rs2.getString("title") %></a></li>
				<%
					}
				%>
			</ol>
		</div>
	</div>
	<form action="writeText_do.jsp" method="post" enctype="multipart/form-data">
	<div id="main">
		<fieldset id="info">
			제목: <input type="text" name="title" class="result"><br>
			글쓴이: <input type="text" name="author" class="result"><br>
			파일 첨부 <input type="file" accept="image/jpg, image/gif" name="fileName" class="result">
		</fieldset>
		<div id="mainText">
			<div>
				<textarea cols="230" rows="50" name="mainArticle" class="result">본문 입력</textarea>
			</div>
			<div>
				<input type="reset" value="초기화"></input>
				<input type="submit" value="등록"></input>
			</div>
		</div>
	</div>
	</form>
</div>
<%
		rs.close();
		pstmt.close();
		con.close();
	}catch(SQLException e) {
		out.println(e);
		return;
	}catch(Exception e) {
		out.println(e);
		return;
	}
%>
</body>
</html>