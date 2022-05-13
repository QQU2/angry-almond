package com.join.vo;

import java.sql.Date;

// 회원정보를 하나하나(id, pw, gender, age..) 불러오는 것이 번거롭기 때문에
//회원 정보를 한번에 담아두기 위한 객체로 활용
public class JoinVO {
	private String userID;
	private String userPW;
	private String userName;
	private char gender;	 //성별 f,m만 받음
	private int age;
	private Date createDate; //Date: java.sql을 임포트

	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	
	public String getUserPW() {
		return userPW;
	}
	public void setUserPW(String userPW) {
		this.userPW = userPW;
	}
	
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public char getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = (gender.charAt(0) == '남') ? 'M' : 'F';
	}
	
	public int getAge() {
		return age;
	}
	public void setAge(String age) {
		this.age = Integer.parseInt(age);
	}
	
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	
	
}
