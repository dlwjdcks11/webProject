<%@ page contentType="text/html;charset=utf-8" import="java.sql.*, java.io.*" %>
<%
request.setCharacterEncoding("utf-8");
 
try {
	int idx = Integer.parseInt(request.getParameter("idx"));
	Class.forName("org.mariadb.jdbc.Driver");
	
	String DB_URL = "jdbc:mariadb://localhost:3306/snsboard?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD= "1234";
	Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	
	String sql = "SELECT fileName FROM article WHERE idx=?";
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setInt(1, idx);
	ResultSet rs = pstmt.executeQuery();
	rs.next();
	String filename = rs.getString("fileName");
	 
	ServletContext context = getServletContext();
	String realFolder = context.getRealPath("upload");
	
	File file = new File(realFolder + "\\" + filename);
	file.delete();
	
	sql = "DELETE FROM article WHERE idx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setInt(1, idx);
	pstmt.executeUpdate();
	
	sql = "DELETE FROM comment WHERE idx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setInt(1, idx);
	pstmt.executeUpdate();
	
	rs.close();
	pstmt.close();
	con.close();
} catch (SQLException e) {
	out.println(e.toString());
	return;
} catch (Exception e) { 
	out.println(e.toString());
	return;
}

response.sendRedirect("mainPage.jsp");   
%> 