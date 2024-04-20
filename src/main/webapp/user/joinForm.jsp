<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>

<div class="container">

	<form action="/project4/user?cmd=join" method="post" onsubmit="return valid()">	<!-- UserController의 cmd.equals("join") 으로 전달
																																								onsubmit : submit 되면 무조건 실행되는 함수-->
		<div class="form-group">
			<div class="d-flex justify-content-between">
				<label>Username :</label> 
				<button type="button" class="btn btn-info"  onclick="usernameCheck()">중복확인</button>
			</div>				
			<input type="text" name="username" id="username" class="form-control" placeholder="Enter Username" required/>
			<!-- 반응형..?? -->
			<font id="checkId" size = "2"></font>
		</div>
		
		<div class="form-group">
			<label>Password :</label> 
			<input type="password" name="password" class="form-control" placeholder="Enter Password" >
		</div>
		
		<div class="form-group">
			<label>Email :</label> 
			<input type="email"  name="email" class="form-control" placeholder="Enter Email" >
		</div>
		<div class="form-group">
			<div class="d-flex justify-content-between">
				<label>Address :</label> 
				<button type="button" class="btn btn-info" onclick="goPopup();">주소검색</button> <!-- type="button"을 설정하지 않으면 submit이 실행된다 -->
			</div>
			<input type="text"  name="address" id="address"class="form-control" placeholder="Enter Address" required readOnly/>
		</div>

<!-- 아이디 기억하기   -->
<!-- 		<div class="form-group form-check">
			<label class="form-check-label"> 
				<input class="form-check-input" type="checkbox"> Remember me
			</label>
		</div> -->
		<br>
		<button type="submit" class="btn btn-primary">회원가입 완료</button>
	</form>

</div>
 
<script>
var isChecking = false;

function valid(){
	alert("아이디 중복체크를 하세요");
	
	if(isChecking == false){
		alert("아이디 중복체크를 하세요");
	}
	return isChecking;
}

// 아이디 중복 체크 ajax 실행 함수
function usernameCheck(){
	// DB에서 확인 후 아이디가 중복이 아니면 isChecking = true로 변경
	var username = $("#username").val();
	
	/*
	// type test (json과 text)
	var a = "{\"result\" : \"a\"}";
	var b = {result: "b"}
	
	console.log(a);				// text (결과값의 외형은 json 같지만 text type 이다)
	console.log(b);				// json (데이터를 Java object로 다 바꿔줌 / key:value 로 엮인 json type이다)
	console.log(b.result);		// json일 경우, Java object로 바꾸기 때문에 .result 같은 기능을 사용할 수 있음
	*/
	
 	$.ajax({
		type: "POST",
		url: "/project4/user?cmd=usernameCheck",
		data: username,
		contentType: "text/plain; charset=utf-8",
		dataType: "text"				// 응답받을 데이터 타입 ("json"은 Java object로 파싱해줌)
	}).done(function(data){		// .done() : 통신이 끝나면 실행할 기능
		if(username === ''){			// 유저네임이 공란
			console.log('공란 : data : ' + data);
			console.log('공란 : username : ' + username);

			isChecking = false;			// 신규 아이디로 중복허용 후, 다시 중복된 아이디로 회원가입할 수 있으니 잘못된 경우는 다 isChecking="false"로
			//alert('유저네임을 입력해주세요.')
			$("#checkId").html('유저네임을 입력해주세요.');
			$("#checkId").attr('color', 'red');
		}else if(data === 'ok'){		// 유저네임이 중복 됨
			console.log('중복 : data : ' + data);
			console.log('중복 : username : ' + username);
			
			isChecking = false;
			//alert('유저네임이 중복되었습니다.')
			$("#checkId").html('유저네임이 중복되었습니다.');
			$("#checkId").attr('color', 'red');
		}else{									// 유저네임이 중복 안 됨
			console.log('신규 : data : ' + data);
			console.log('신규 : username : ' + username);

			isChecking = true;
			//alert('해당 유저네임은 사용가능합니다.')
			$("#checkId").html('해당 유저네임은 사용가능합니다.');
			$("#checkId").attr('color', 'blue');
		}
	});
	
}

// 주소 API 실행 함수
function goPopup(){
	var pop = window.open("/project4/user/jusoPopup.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
}

function jusoCallBack(roadFullAddr){
	var addressElement = document.querySelector("#address");	
	addressElement.value = roadFullAddr;
}

</script>

</body>
</html>