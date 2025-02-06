<%--
  Created by IntelliJ IDEA.
  User: human-15
  Date: 25. 2. 6.
  Time: 오후 12:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
  /* 챗봇 버튼 스타일 */
  .chatbot-btn {
    position: fixed;
    bottom: 20px;
    right: 20px;
    background-color: #007bff;
    color: white;
    border: none;
    width: 60px;  /* 버튼 너비 */
    height: 60px; /* 버튼 높이 */
    border-radius: 50%;  /* 완전 원형 */
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 24px;  /* 아이콘 크기 */
    cursor: pointer;
    z-index: 1000;
  }

  /* 챗봇 모달 스타일 */
  .chatbot-modal {
    display: none;  /* 기본적으로 숨김 */
    position: fixed;
    bottom: 90px;  /* 버튼 바로 위에 위치 */
    right: 20px;
    width: 350px;  /* 모달의 넓이 */
    height: 400px;  /* 모달의 높이 */
    background-color: white;
    border: 1px solid #ccc;
    border-radius: 10px;
    box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
    z-index: 999;
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }

  /* 모달 내용 영역 */
  .chatbot-modal .modal-content {
    flex: 1;
    overflow-y: auto;
    padding: 10px;
    height: calc(100% - 50px);  /* 메시지 입력창 제외 */
  }

  /* 모달 입력창 고정 */
  .chatbot-modal .modal-input {
    position: sticky;
    bottom: 0;
    width: 100%;
    background-color: #f1f1f1;
    padding: 10px;
    border-top: 1px solid #ccc;
    box-sizing: border-box;
  }

  /* 메시지 입력창 스타일 */
  .chatbot-modal .modal-input input {
    width: calc(100% - 20px);
    padding: 8px;
    border: none;
    border-radius: 5px;
    font-size: 16px;
    background-color: #fff;
  }

  /* 메시지 입력창 버튼 */
  .chatbot-modal .modal-input button {
    background-color: #007bff;
    color: white;
    border: none;
    padding: 8px 15px;
    border-radius: 5px;
    cursor: pointer;
  }
</style>

<html>
  <head>
    <title>Title</title>
  </head>
  <body>

  <!-- 챗봇 버튼 -->
  <button class="chatbot-btn" onclick="toggleModal()">챗봇</button>

  <!-- 챗봇 모달 -->
  <div class="chatbot-modal" id="chatbotModal">
    <!-- 모달 내용 영역 -->
    <div class="modal-content">
      <!-- 여기에 챗봇 메시지 내용이 들어갑니다. -->
      <div class="message" id="chatbotMessages"></div>
    </div>

    <!-- 메시지 입력창 -->
    <div class="modal-input">
      <input type="text" id="chatInput" placeholder="메시지를 입력하세요" />
      <button onclick="sendMessage()">전송</button>
    </div>
  </div>

  <script>
    // 챗봇 모달 토글 함수
    function toggleModal() {
      var modal = document.getElementById('chatbotModal');
      modal.style.display = modal.style.display === 'block' ? 'none' : 'block';
    }

    // 메시지 전송 함수
    function sendMessage() {
      var input = document.getElementById('chatInput');
      var message = input.value;
      if (message.trim() !== "") {
        // 사용자 메시지 표시
        var chatbotMessages = document.getElementById('chatbotMessages');
        var newMessage = document.createElement('div');
        newMessage.classList.add('user-message');
        newMessage.textContent = message;
        chatbotMessages.appendChild(newMessage);

        // 메시지 입력창 비우기
        input.value = '';

        // Gemini API 호출
        fetch("http://localhost:8501/gemini", {
          method: "POST",
          headers: {
            "Content-Type": "application/json"
          },
          body: JSON.stringify({ "message": message })
        })
                .then(response => response.json())
                .then(data => {
                  // AI 응답 표시
                  var aiMessage = document.createElement('div');
                  aiMessage.classList.add('ai-message');
                  aiMessage.textContent = data.response;  // AI 응답 내용
                  chatbotMessages.appendChild(aiMessage);

                  // 스크롤을 맨 아래로
                  chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
                })
                .catch(error => {
                  console.error('Error:', error);
                });
      }
    }
  </script>



  </body>
</html>
