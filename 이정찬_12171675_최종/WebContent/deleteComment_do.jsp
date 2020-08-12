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
	ResultSet rs = null;
	
	int pkIdx = Integer.parseInt(request.getParameter("pkIdx"));
	int idx = 0;
	
	try {
		con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		
		String sql = "SELECT idx FROM comment WHERE pkIdx=?";
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, pkIdx);
		rs = pstmt.executeQuery();
		rs.next();
		idx = rs.getInt("idx");
		
		sql = "DELETE FROM comment WHERE pkIdx=?";
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, pkIdx);
		pstmt.executeUpdate();
		
		sql = "UPDATE article SET view=view-1 WHERE idx=?";
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, idx);
		pstmt.executeUpdate();
		
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
	
	response.sendRedirect("printArticle.jsp?idx=" + idx);
%>