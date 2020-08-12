<%@ page contentType="text/html;charset=utf-8" 
		import="com.oreilly.servlet.*, com.oreilly.servlet.multipart.*"
		import="java.sql.*, java.io.*, java.util.Date, java.text.SimpleDateFormat" %>
<%
	request.setCharacterEncoding("utf-8");

	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/snsboard?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD= "1234";

	ServletContext context = getServletContext();
	String realFolder = context.getRealPath("upload");
	
	int maxsize = 10 * 1024 * 1024;

	try {
		MultipartRequest multi = new MultipartRequest(request, realFolder, maxsize, "utf-8", new DefaultFileRenamePolicy());

		String title = multi.getParameter("title");
		String author = multi.getParameter("author");
		String mainArticle = multi.getParameter("mainArticle");
		String fileName = multi.getFilesystemName("fileName");
        
		Date nowTime = new Date();
		SimpleDateFormat sf = new SimpleDateFormat("yyyy년 MM월 dd일 a hh:mm:ss");
		String time = sf.format(nowTime);

		Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		
		String sql = "INSERT INTO article(title, author, mainArticle, fileName, time) VALUES (?, ?, ?, ?, ?)";
		
		PreparedStatement pstmt = con.prepareStatement(sql);

		pstmt.setString(1, title);
		pstmt.setString(2, author);
		pstmt.setString(3, mainArticle);
		pstmt.setString(4, fileName);
		pstmt.setString(5, time);
		pstmt.executeUpdate();
		
		pstmt.close();
		con.close();

	} catch(IOException e) { 
		out.println(e);
		return;
	} catch(SQLException e) {
		out.println(e);
		return;
	} catch(Exception e) {
		out.println(e);
		return;
	}
	response.sendRedirect("mainPage.jsp");
%>