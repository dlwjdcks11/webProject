<%@ page contentType="text/html; charset=UTF-8"
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
	
	String idx = request.getParameter("idx");
	
	try {
		con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		
		String sql = "SELECT fileName FROM article WHERE idx=?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, idx);
		
		rs = pstmt.executeQuery();
		rs.next();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>큰 사진 보기</title>
</head>
<body>
<a href="mainPage.jsp"><img src="./upload/<%=rs.getString("fileName") %>" width="500" height="500"></a>
<h2>사진을 한번 더 누르면 메인페이지로 이동합니다.</h2>
<%
	rs.close();
	pstmt.close();
	con.close();
	
	} catch(SQLException e) {
		out.println(e);
		return;
	} catch(Exception e) {
		out.println(e);
		return;
	}
%>
</body>
</html>