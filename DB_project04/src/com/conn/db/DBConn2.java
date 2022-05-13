package com.conn.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;


public class DBConn2 {
	
	private final static String Driver_name = "oracle.jdbc.driver.OracleDriver";
	private final static String Base_url = "jdbc:oracle:thin:@";
	private String url_address;
	private Connection conn;
	private Statement stat;
	
	//로컬, 도커용 생성자
	public DBConn2(String address, String port, String serviceName, String username, String pw) throws Exception {
		url_address = String.format("%s:%s/%s", address, port, serviceName);
		createConnection(username, pw);
	}
	
	//클라우드용 생성자
//	public DBConn2(String tnsAlias, String walletPath, String username, String pw) throws Exception {
//		url_address = String.format("%s?TNS_ADMIN=%s", tnsAlias, walletPath);
//		createConnection(username, pw);
//	}
	
	//파일 로드받아 연결하는 생성자
	public DBConn2(File config) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		BufferedReader br = new BufferedReader(new FileReader(config));
		
		while(br.ready()) {
			String[] keyValues = br.readLine().split(" = ");
			map.put(keyValues[0], keyValues[1]);
		}
		url_address = String.format("%s:%s/%s", map.get("host"), map.get("port"), map.get("service"));
		createConnection(map.get("username"), map.get("pw"));
	
	}
	
	private void createConnection(String username, String pw) throws Exception {
		Class.forName(Driver_name);
		conn = DriverManager.getConnection(Base_url + url_address, username, pw);
		stat = conn.createStatement();
		
	}
	public ResultSet sendSelectQuery(String query) throws Exception{
		return this.stat.executeQuery(query);
	}
	public int sendInsertQuery(String query) throws Exception{
		return this.stat.executeUpdate(query);
	}
	public int sendUpdateQuery(String query) throws Exception{
		return this.stat.executeUpdate(query);
	}
	public int sendDeleteQuery(String query) throws Exception{
		return this.stat.executeUpdate(query);
	}
	public void close() throws Exception{
		this.stat.close();
		this.conn.close();
	}
}






