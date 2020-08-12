<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");

	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/snsboard?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD= "1234";

	Connection con= null;
	PreparedStatement pstmt = null;
	
	String idx = request.getParameter("idx");
	
	try {
		con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		String sql = "UPDATE article SET star=star+1, view=view-1 WHERE idx=?";
		pstmt = con.prepareStatement(sql);
		
		pstmt.setString(1, idx);
		pstmt.executeUpdate();
		
		pstmt.close();
		con.close();
	} catch(SQLException e) {
		out.println(e);
		return;
	} catch(Exception e) {
		out.println(e);
		return;
	}
	
	response.sendRedirect("printArticle.jsp?idx=" + idx);
%>