package com.join.view;

import java.util.Scanner;

import com.join.controller.JoinController;
import com.join.menu.JoinMenu;
import com.join.vo.JoinVO;
public class JoinView {
	//CLI(터미널) 화면에 메뉴(회원가입 탈퇴, 정보수정) 및 정보를 보여줌
	//사용자가 데이터를 입력할 수 있는 화면을 제공
	private JoinController jc = new JoinController();
	private Scanner sc = new Scanner(System.in);
	private JoinMenu menu = new JoinMenu();
	
	public void show() {
		while(true) {
			System.out.print(menu.getMain());
			System.out.print(">>> ");
			int choose = sc.nextInt();
			sc.nextLine();
			
			switch(choose) {
			case 1: joinMenu();		break;
			case 2: loginMenu();	break;
			case 3: System.exit(0);
			default: System.out.println("잘못 입력하셨습니다. 다시 입력하세요.");
			}
		}
	}
	public void joinMenu() {//회원가입(JoinController의 함수를 호출기능)
		//1. 사용자 입력을 사용하여 회원가입에 필요한 모든 정보를 입력받는다.
		//2. JoinVO 객체에 사용자가 입력한 정보를 저장하는 작업을 진행한다.
		//3. 가입일자는 제외한 모든 정보 입력/ 성별은 남 또는 여로 받고 'M', 'F'로 변환하여 저장
		JoinVO jv = new JoinVO();
		
		System.out.print("     아이디 : ");
		jv.setUserID(sc.nextLine());
		
		System.out.print("   패스워드 : ");
		jv.setUserPW(sc.nextLine());
		
		System.out.print("   본인이름 : ");
		jv.setUserName(sc.nextLine());
		
		System.out.print("성별(남/여) : ");
		jv.setGender(sc.nextLine());
		
		System.out.print("       나이 : ");
		jv.setAge(sc.nextLine());
		
		
		boolean result = jc.join(jv);
		if(result) {
			System.out.println("회원가입이 완료되었습니다.");
		}else {
			System.out.println(">>아이디 중복<< 회원가입을 할 수 없습니다.");
		}
	}
	public void loginMenu() {//로그인
		System.out.print("아이디: ");
		String id = sc.nextLine();
		
		System.out.print("비밀번호: ");
		String pw = sc.nextLine();
		
		JoinVO account = jc.login(id, pw);
		if(account != null) {
			System.out.println(account.getUserID() + "님, 로그인되었습니다.");
			//로그인 이후 마이페이지 메뉴가 뜨게 만듦
			this.afterLoginMenu(account);
		}else {
			System.out.println("아이디 혹은 비밀번호가 틀립니다.");
		}
	}
	public void afterLoginMenu(JoinVO account) {
		while(true) {
			System.out.print(menu.getAfterLogin(account.getUserID()));
			System.out.print(">>>");
			String input = sc.nextLine();
			
			switch(input) {
			//1. 정보수정
			case "1": 
				System.out.println("아무것도 입력하지 않으면 이전 데이터를 유지합니다.");
				System.out.print("변경할 비밀번호: ");
				input = sc.nextLine();
				input = input.isEmpty()? account.getUserPW() : input;
				account.setUserPW(input);
				
				System.out.print("변경할 이름: ");
				input = sc.nextLine();
				input = input.isEmpty()? account.getUserName() : input;
				account.setUserName(input);
				
				System.out.print("변경할 성별(남 / 여): ");
				input = sc.nextLine();
				input = input.isEmpty()?Character.toString(account.getGender()) : input;
				account.setGender(input);
				
				System.out.print("변경할 나이: ");
				input = sc.nextLine();
				input = input.isEmpty()? Integer.toString(account.getAge()) : input;
				account.setAge(input);
				
				if(jc.update(account)) {
					System.out.println("정보 수정 완료");
				}else {
					System.out.println("정보 수정 실패");
				}
				break;
				
			//2. 회원탈퇴
			case "2": 
				System.out.println("패스워드: ");
				input = sc.nextLine();
				
				if(jc.remove(account, input)) {
					System.out.println("회원탈퇴가 성공적으로 이루어졌습니다.");
					return;
				} else{
					System.out.println("비밀번호가 일치하지 않습니다.");
				}
				break;
				
			//3. 로그아웃
			case "3": account = null; return;
			default:
				System.out.println("잘못 입력하셨습니다. 다시 입력하세요.");
			}
			
		}
		
	}
}
