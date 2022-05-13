package com.conn.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DBConn {
	public void  localConnect() throws Exception {
		//1. driver 등록, 로드, 객체화
		Class.forName("oracle.jdbc.driver.OracleDriver");
		
		//2. DBMS 연결(url(jdbc:oracle:thin:@) ip address host:PORT/Service name, DB user, DB pw)
		Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:15210/XE", "puser1", "puser1");
		
		//3. Statement(실행도구) 생성
		Statement stat = conn.createStatement();
		
		//4. SQL 질의문 전송 및 반환(문자열 안에 ;넣으면 안됨)
			//int rowCount = stat.executeUpdate("INSERT INTO DEPARTMENTS VALUES(280, 'Tester', NULL, '1700')");
			//int rowCount = stat.executeUpdate("UPDATE DEPARTMENTS SET DEPARTMENT_NAME = 'DEPT_Tester' WHERE DEPARTMENT_ID = 280");
			int rowCount = stat.executeUpdate("DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID = 280");
			ResultSet rs = stat.executeQuery("SELECT * FROM DEPARTMENTS ORDER BY DEPARTMENT_ID");
			// rs = stat.executeQuery("SELECT * FROM DEPARTMENTS");
			// rs = stat.executeQuery("SELECT 'Hello' FROM DUAL");
			
		while(rs.next()) {//다음 행으로 이동 가능한지에 대한 if문
			//1개 행 데이터만 조회가능
			System.out.print(rs.getString(1) + "\t");
			System.out.print(rs.getString(2) + "\t");
			System.out.print(rs.getString(3) + "\t");
			System.out.print(rs.getString(4) + "\n");
		}
		
		//5. 객체 반환: 만든 순서를 거꾸로 반환
		rs.close();
		stat.close();
		conn.close();
	}
	public static void main(String[] args) throws Exception {
		DBConn myDB = new DBConn();
		myDB.localConnect();
		

	}

}
