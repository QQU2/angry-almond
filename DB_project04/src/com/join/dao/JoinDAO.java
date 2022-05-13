package com.join.dao;

import java.io.File;
import java.sql.ResultSet;

import com.conn.db.DBConn2;
import com.join.vo.JoinVO;

//DAO: Database Access Object
// 모든 데이터 처리 함수
public class JoinDAO {
	 private DBConn2 db;
	 
	public JoinDAO() {
		 try {
//			 db = new DBConn2("localhost", "15210", "XE", "puser1", "puser1");
			 db= new DBConn2(new File(System.getProperty("user.home" + "/oracle_db.conf")));
		} catch (Exception e) {
			e.printStackTrace();
		}
	 }
	
	public boolean add(JoinVO data) {//추가
		 String query = String.format("INSERT INTO ACCOUNTS VALUES('%s', '%s', '%s', '%c', %d, SYSDATE)" 
				 					, data.getUserID(), data.getUserPW()
				 					, data.getUserName() 
				 					, data.getGender(), data.getAge());
		 try {
			int outInsert = db.sendInsertQuery(query);
			if(outInsert == 1) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	 }
	//1. 회원정보를 저장할 accounts 테이블을 생성(제약조건 X)
	 // 	- 컬럼: 아이디, 패스워드, 사용자명(varchar2(20))
	 //2. JoinDAO.add() 메서드에서 데이터를 추가할 수 있는 query문 만들기'
	 //3. 실제 accounts테이블에 데이터가 추가되었는지 확인
	 public boolean modify(JoinVO account) {
		 //수정
		 String query = "UPDATE ACCOUNTS "
		 				+ "SET PW = '" + account.getUserPW() + "'"
		 				+ ", USER_NAME = '" + account.getUserName() + "'"
		 				+ ", GENDER = '" + account.getGender() + "'"
		 				+ ", AGE = '" + account.getAge() + "'"
		 				+ "WHERE ID = '" + account.getUserID() + "'";
		 try {
			int rs = db.sendUpdateQuery(query);
			if(rs == 1) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		 return false;
	 }
	 
	 public boolean remove(JoinVO account) {//제거
		 String query = "DELETE FROM ACCOUNTS "
		 			  + "WHERE ID = '" + account.getUserID() + "'";
		try {
			int rs = db.sendDeleteQuery(query);
			if(rs == 1) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		 return false;
	 }
	 
	 public JoinVO get(String id) {//조회
		 String query = String.format("SELECT * FROM ACCOUNTS WHERE ID = '%s'", id);
		 try {
			ResultSet rs = db.sendSelectQuery(query);
			if(rs.next()) {
				JoinVO jv = new JoinVO();
				jv.setUserID(rs.getString("ID")); 
				jv.setUserPW(rs.getString("PW")); 
				jv.setUserName(rs.getString("USER_NAME")); 
				jv.setGender(rs.getString("GENDER")); 
				jv.setAge(rs.getString("AGE")); 
				jv.setCreateDate(rs.getDate("CREATEDATE")); 
				return jv;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		 return null;
	 }
}
