<%@ page contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>검색 결과</title>
<link rel="stylesheet" type="text/css" href="mainPage_css.css">
<link rel="stylesheet" type="text/css" href="outline.css">
</head>
<body>
<%
	Class.forName("org.mariadb.jdbc.Driver");
	String search = request.getParameter("search");

	String DB_URL = "jdbc:mariadb://localhost:3306/snsboard?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD= "1234";
	int total = 0;

	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	PreparedStatement pstmt2 = null;
	ResultSet rs2 = null;
	
	PreparedStatement pstmt3 = null;
	ResultSet rs3 = null;

	try {
		con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		String sql = "SELECT *, (SELECT COUNT(*) FROM comment WHERE comment.idx = article.idx) AS comment_count FROM article WHERE (title LIKE ?) OR (mainArticle LIKE ?)";
		
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, "%"+search+"%");
		pstmt.setString(2, "%"+search+"%");
		rs = pstmt.executeQuery();
		
		String sql2 = "SELECT idx, title FROM article ORDER BY view DESC LIMIT 0, 5";
		pstmt2 = con.prepareStatement(sql2);
		rs2 = pstmt2.executeQuery();
		
		String sql3 = "SELECT idx, title FROM article ORDER BY star DESC LIMIT 0, 3";
		pstmt3 = con.prepareStatement(sql3);
		rs3 = pstmt3.executeQuery();
%>
<div id="wrap">
	<div id="title">
		<h1><a href="mainPage.jsp">모두의 자유게시판</a></h1>
	</div>	
	<div id="link">
		<a href="writeText.jsp">글 등록</a>
	</div>
</div>
<div id="wrap2">
	<div id="side">
		<div class="sideInfo">
		조회수 순위
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
		최근 본 글
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
	<div id="main">
		<div id="search">
		<form action="search.jsp" method="get">
			<input type="text" name="search">
			<input type="submit" value="검색">
		</form>
		</div>
		<div class="post">
		<%
			while(rs.next()) {
		%>
				<table border="1" style="border-collapse: collapse;">
				<tr>
					<td>
						<a href="printArticle.jsp?idx=<%=rs.getInt("idx") %>">제목: <%=rs.getString("title") %></a>
					</td>
					<td>작성일자: <%=rs.getString("time") %></td>
					<td>조회 수: <%=rs.getInt("view") %></td>
					<td>댓글: <%=rs.getInt("comment_count") %>개</td>
					<td>추천 수: <%=rs.getInt("star") %>개</td>
					<td>
						<a href="modifyArticle.jsp?idx=<%=rs.getInt("idx") %>">수정</a> <!-- 수정, 삭제 비밀번호 체크 필요 -->
					</td>
					<td>
						<a href="deleteArticle_do.jsp?idx=<%=rs.getInt("idx") %>">삭제</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="viewBigPicture.jsp?idx=<%=rs.getInt("idx") %>">
							<img src="./upload/<%=rs.getString("fileName") %>" width="50" height="50">
						</a>
					</td>
					<td colspan="6">
						<% 
							if(rs.getString("mainArticle").length() >= 100)
							{
								String article = rs.getString("mainArticle").substring(0, 99) + "... 더 보려면 제목을 누르세요";
						%>
							<%=article %>
						<%
							}
						%>
						<%
							if(rs.getString("mainArticle").length() < 100)
							{
						%>
							<%=rs.getString("mainArticle") %>
						<%
							}
						%>
					</td>
				</tr>
			</table>
			<br>
		<%
			total++;
			}
		
			if(total == 0) {
		%>
			<h2 style="text-align: center;">검색 결과가 없습니다.</h2>
		<%
			}
			if(total != 0) {
		%>
			<h2 style="text-align: center;">총 <%=total %>개의 글이 검색되었습니다.</h2>
		<%
			}
		%>
		</div>
	</div>
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