<%@ page contentType="text/html;charset=utf-8" 
		import="java.sql.*, java.util.Date, java.text.SimpleDateFormat" %>
<%
	request.setCharacterEncoding("utf-8");

	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/snsboard?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD= "1234";
	
	String idx = request.getParameter("idx");
	String author = request.getParameter("author");
	String mainComment = request.getParameter("mainComment");
	
	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyy년 MM월 dd일 a hh:mm:ss");
	String time = sf.format(nowTime);
	
	Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		
	String sql = "INSERT INTO comment(idx, author, mainComment, time) VALUES (?, ?, ?, ?)";
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1, idx);
	pstmt.setString(2, author);
	pstmt.setString(3, mainComment);
	pstmt.setString(4, time);
	pstmt.executeUpdate();
	
	sql = "UPDATE article SET view=view-1 WHERE idx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1, idx);
	pstmt.executeUpdate();
		
	pstmt.close();
	con.close();

	response.sendRedirect("printArticle.jsp?idx=" + Integer.parseInt(idx));
%>