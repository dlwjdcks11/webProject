<%@ page contentType="text/html; charset=UTF-8" import="java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");

	int idx = Integer.parseInt(request.getParameter("idx"));

	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/snsboard?useSSL=false";

	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	PreparedStatement pstmt2 = null;
	ResultSet rs2 = null;
	
	PreparedStatement pstmt3 = null;
	ResultSet rs3 = null;
	
	con = DriverManager.getConnection(DB_URL, "admin", "1234");

	String sql = "SELECT * FROM article WHERE idx=?";

	pstmt = con.prepareStatement(sql);
	pstmt.setInt(1, idx);
	rs = pstmt.executeQuery();
	rs.next();
	
	String sql2 = "SELECT idx, title FROM article ORDER BY view DESC LIMIT 0, 5";
	pstmt2 = con.prepareStatement(sql2);
	rs2 = pstmt2.executeQuery();
	
	String sql3 = "SELECT idx, title FROM article ORDER BY star DESC LIMIT 0, 3";
	pstmt3 = con.prepareStatement(sql3);
	rs3 = pstmt3.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 수정</title>
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
					while(rs2.next()) {
				%>
					<li><a href="printArticle.jsp?idx=<%=rs2.getInt("idx") %>"><%=rs2.getString("title") %></a></li>
				<%
					}
				%>
			</ol>
		</div>
		<div class="sideInfo">
		추천 수 순위
			<ol type="1">
				<%
					while(rs3.next()) {
				%>
					<li><a href="printArticle.jsp?idx=<%=rs3.getInt("idx") %>"><%=rs3.getString("title") %></a></li>
				<%
					}
				%>
			</ol>
		</div>
	</div>
	<form action="modifyArticle_do.jsp" method="post" enctype="multipart/form-data">
	<div id="main">
		<fieldset id="info">
			<input type="hidden" name="idx" value=<%=idx %>>
			<input type="hidden" name="time" value=<%=rs.getString("time") %>>
			제목: <input type="text" name="title" class="result" value=<%=rs.getString("title") %>><br>
			글쓴이: <input type="text" name="author" class="result" value=<%=rs.getString("author") %>><br>
			<img src="./upload/<%=rs.getString("fileName") %>" width="100" height="100">
			파일 변경 <input type="file" accept="image/jpg, image/gif" name="fileName" class="result">
		</fieldset>
		<div id="mainText">
			<div>
				<textarea cols="230" rows="50" name="mainArticle" class="result"><%=rs.getString("mainArticle")%></textarea>
			</div>
			<div>
				<input type="reset" value="취소"></input>
				<input type="submit" value="등록"></input>
			</div>
		</div>
	</div>
	</form>
</div>
<% 
rs2.close();
pstmt2.close();

rs.close();
pstmt.close();
con.close();
%>
</body>
</html>