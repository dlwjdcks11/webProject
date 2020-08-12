<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*"
    import="java.util.Date, java.text.SimpleDateFormat"%>
<%
	request.setCharacterEncoding("utf-8");

	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/snsboard?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD= "1234";

	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String pkIdx = request.getParameter("pkIdx");
	String modifiedComment = request.getParameter("modifiedComment");
	int idx = 0;
	
	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyy년 MM월 dd일 a hh:mm:ss");
	String time = sf.format(nowTime);
	
	try {
		con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	
		String sql = "UPDATE comment SET mainComment=?, time=? WHERE pkIdx=?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, modifiedComment);
		pstmt.setString(2, time);
		pstmt.setString(3, pkIdx);
		pstmt.executeUpdate();	
		
		sql = "SELECT idx FROM comment WHERE pkIdx=?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, pkIdx);
		rs = pstmt.executeQuery();
		rs.next();
		idx = rs.getInt("idx");
		
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