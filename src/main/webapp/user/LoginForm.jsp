<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/check.png" alt="Logo" style="width:50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">로그인</div>
	</div>
</h1>
<br>
<br>


<div class="container" style="text-align: center">

	<form action="/project4/user?cmd=login" method="post"  name="loginSuccess">
	<!-- <form> 태그에 데이터를 담아서 POST 로 보내면 Key=Value 형태로 간다 (x-www-form-urlencoded) -->
		<div class="form-group">
			<div class="material-icons-input">
			    <span class="material-icons">person_outline</span>
			    <input type="text" name="username" id="username" class="form-control" placeholder="Enter Username" required />
			</div>	
		</div>
		
		<div class="form-group">
			<div class="material-icons-input">
			    <span class="material-icons">lock_outline</span>
				<input type="password" name="password" id="password" class="form-control" placeholder="Enter Password" required/>
			</div>	
			
		</div>
		<!-- ajax -->
		<p><font id="checkLog" size = "2"></font></p>
		
		<div class="custom-control custom-switch">
			<input type="checkbox" class="custom-control-input" id="switch1" name="example">
			<label class="custom-control-label" for="switch1">아이디 기억하기</label>
		</div>
		
		<br>
		<div>
   			 <button type="button" onclick="logCheck();" id="login" class="mr-auto btn btn-primary" style="width: 25%">로그인 하기</button>
		</div>
		<br>
	</form>
</div>

<div class="container d-flex justify-content-center" style="width: 35%; color: grey;">
	<div onclick="searchUsername()" style="cursor: pointer;">아이디 찾기</div> ㅣ 
	<div onclick="searchPassword()" style="cursor: pointer;">비밀번호 찾기</div>
</div>
		 
<script src="/project4/js/userInfo.js"></script>

</body>
<style>
    .material-icons-input {								/* input 될 아이콘 칸 */
        display: inline-block;
        position: relative;
    }
    .material-icons-input input {						/* 아이콘이 포함된 input 태그 */
	    width: 100%;
	    padding-left: 40px; /* 예시: 좀 더 넓은 여백을 주기 위해 padding-left 값 조정 */
    }
    .material-icons-input .material-icons {		/* 아이콘 위치 */
        position: absolute;
        left: 5px; /* 아이콘을 왼쪽에 위치 */
        top: 50%;
        transform: translateY(-50%);
    }
</style>

</html>