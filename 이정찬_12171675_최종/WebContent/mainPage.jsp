<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*"
    import="com.oreilly.servlet.*, com.oreilly.servlet.multipart.*" %>
<%
	request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 메인페이지</title>
<link rel="stylesheet" type="text/css" href="mainPage_css.css">
<link rel="stylesheet" type="text/css" href="outline.css">
<script>
function openPicture(idx) {
	var url = "viewBigPicture.jsp?idx="+idx;
	location.href= url;
}
function deleteCheck(idx) {
	if(confirm("삭제하시겠습니까?"))
	{
		location.href= "deleteArticle_do.jsp?idx="+idx;
		return true;
	} 
	else 
	{
		return false;
	}
}
</script>
</head>
<body>
<%
	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/snsboard?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD= "1234";

	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	
	PreparedStatement pstmt2 = null;
	ResultSet rs2 = null;
	
	PreparedStatement pstmt3 = null;
	ResultSet rs3 = null;
	
	int total = 0;
	
	try {
		con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		String sql = "SELECT *, (SELECT COUNT(*) FROM comment WHERE comment.idx = article.idx) AS comment_count FROM article";
		pstmt = con.prepareStatement(sql);
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
		<h1><a href="mainPage.jsp" style="text-decoration:none;">모두의 자유게시판</a></h1>
	</div>	
	<div id="link">
		<a href="writeText.jsp">글 등록</a>
	</div>
</div>
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
	<div id="main">
		<div id="search">
		<form action="search.jsp" method="get">
			<input type="text" name="search" placeholder="제목 or내용 검색">
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
						<a href="#" onclick="deleteCheck('<%=rs.getInt("idx") %>')">삭제</a>
					</td>
				</tr>
				<tr>
					<td>
						<img src="./upload/<%=rs.getString("fileName") %>" width="50" height="50" onclick="openPicture('<%=rs.getInt("idx")%>')">
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
			<h2 style="text-align: center;">아직 글이 없습니다. 글을 등록해주세요!</h2>
		<%
			}
			if(total != 0) {
		%>
			<h2 style="text-align: center;">총 <%=total %>개의 글이 등록되어 있습니다.</h2>
		<%
			}
		%>
		</div>
	</div>
</div>
<%
		rs3.close();
		pstmt3.close();

		rs2.close();
		pstmt2.close();

		rs.close();
		pstmt.close();
		con.close();
	}catch(SQLException e) {
		out.println(e);
	}
%>
</body>
</html>