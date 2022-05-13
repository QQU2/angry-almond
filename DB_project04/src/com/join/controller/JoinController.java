package com.join.controller;

import com.join.dao.JoinDAO;
import com.join.vo.JoinVO;

public class JoinController {
	private JoinDAO dao = new JoinDAO();
	
	//가입 진행 전에 아이디 중복 확인
	public boolean join(JoinVO data) {
		// 회원 가입 처리 전 필요한 로직 (데이터 검사, 계산 등)-> 데이터베이스에 저장을 직접 처리 X
		// 회원 가입 처리 후 결과를 반환한다.
		
		JoinVO account = dao.get(data.getUserID());
		if(account == null) {
			boolean result = dao.add(data);
			if(result) {
				return true; 
			}
		}
		return false;
	}
	
	public JoinVO login(String id, String pw) {
		//id에 해당하는 계정 유무 확인
		JoinVO account = dao.get(id);
		if(account != null) {
			//해당 계정의 pw와 id의 pw이 동일한 값인지 확인
			if(pw.equals(account.getUserPW())) {
				return account;
			}
		}
		return null; 
		
		//동일한 정보면 사용자 정보 객체(JoinVO) 전달/ 아니면 null전달
	}
	public boolean update(JoinVO account) {
		return dao.modify(account);
	}
	public boolean remove(JoinVO account, String pw) {
		if(pw.equals(account.getUserPW())) {
			return dao.remove(account);
		}
		return false;
	}
}
