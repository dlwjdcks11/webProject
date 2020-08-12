<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, java.io.*, com.oreilly.servlet.*, com.oreilly.servlet.multipart.*"
    import="java.util.Date, java.text.SimpleDateFormat" %>
<%
	request.setCharacterEncoding("utf-8");
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String sql = null;
	
	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/snsboard?useSSL=false";
	
	try {
		con = DriverManager.getConnection(DB_URL, "admin", "1234");
		
		ServletContext context = getServletContext();
		String realFolder = context.getRealPath("upload");
		
		int maxsize = 10 * 1024 * 1024;
		
		MultipartRequest multi = new MultipartRequest(request, realFolder, maxsize, "utf-8", new DefaultFileRenamePolicy());
		
		int idx = Integer.parseInt(multi.getParameter("idx"));
		String title = multi.getParameter("title");
		String author = multi.getParameter("author");
		String mainArticle = multi.getParameter("mainArticle");
		String fileName = multi.getFilesystemName("fileName");
		
		Date nowTime = new Date();
		SimpleDateFormat sf = new SimpleDateFormat("yyyy년 MM월 dd일 a hh:mm:ss");
		String time = sf.format(nowTime);
		
		if (fileName != null)
		{
			sql = "SELECT fileName FROM article WHERE idx=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, idx);
			
			rs = pstmt.executeQuery();
			rs.next();
			String oldFileName = rs.getString("fileName");
			
			File oldFile = new File(realFolder + "\\" + oldFileName);
			oldFile.delete();
			
			sql = "UPDATE article SET title=?, author=?, mainArticle=?, fileName=?, time=? WHERE idx=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, title);
			pstmt.setString(2, author);
			pstmt.setString(3, mainArticle);
			pstmt.setString(4, fileName);
			pstmt.setString(5, time);
			pstmt.setInt(6, idx);
		}
		else
		{
			sql = "UPDATE article SET title=?, author=?, mainArticle=?, time=? WHERE idx=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, title);
			pstmt.setString(2, author);
			pstmt.setString(3, mainArticle);
			pstmt.setString(4, time);
			pstmt.setInt(5, idx);
		}
		
		pstmt.executeUpdate();
		
		if(rs != null) rs.close();
		if(pstmt != null) pstmt.close();
		if(con != null) con.close();	
	} catch(SQLException e) {
		out.println(e);
		return;
	} catch(IOException e) {
		out.println(e);
		return;
	} catch(Exception e) {
		out.println(e);
		return;
	}
	
	response.sendRedirect("mainPage.jsp");
%>