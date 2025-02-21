document.addEventListener("click", function (event) {
    // ✅ 필터 버튼 클릭 감지 (AJAX로 생성된 버튼도 감지 가능!)
    if (event.target.classList.contains("filter-btn")) {
        event.preventDefault();
        // console.log("🎉 필터 버튼 클릭 감지됨:", event.target);

        const tc = event.target.getAttribute("data-tc");
        console.log("📌 선택된 tc 값:", tc);

        if (!tc) {
            console.error("❌ data-tc 값이 없음!");
            return;
        }

        const url = contextPath + "/main/recommended/courseAjax?tc=" + tc;
        console.log("📡 AJAX 요청 URL:", url);

        fetch(url)
            .then(response => response.json())
            .then(data => {
                console.log("📡 AJAX 응답 데이터 확인:", data);
                renderCourseCards(data);
            })
            .catch(err => console.error("❌ AJAX 요청 오류:", err));
    }

    // ✅ `.card-link` 클릭 시 상세 페이지로 이동 (AJAX로 생성된 요소 포함)
    if (event.target.closest(".card-link")) {
        event.preventDefault();
        const link = event.target.closest(".card-link");
        const contentid = link.getAttribute("data-contentid");
        const contenttypeid = link.getAttribute("data-contenttypeid");
        const title = encodeURIComponent(link.getAttribute("data-title"));

        console.log("🔗 이동할 상세페이지 URL:", `/main/recommend/detail?contentid=${contentid}&contenttypeid=${contenttypeid}&title=${title}`);

        window.location.href = `/main/recommend/detail?contentid=${contentid}&contenttypeid=${contenttypeid}&title=${title}`;
    }
});



// ✅ renderCourseCards 함수 수정 (AI 추천 여행지 스타일과 통일)
function renderCourseCards(courseItems) {
    console.log("📌 renderCourseCards 실행됨", courseItems);

    if (!courseItems || courseItems.length === 0) {
        console.warn("⚠️ renderCourseCards: courseItems가 비어 있음!");
        document.getElementById("courseSection").innerHTML = "<p>코스가 없습니다.</p>";
        return;
    }

    let html = '<div class="row row-cols-1 row-cols-md-3 g-4">';
    courseItems.forEach(item => {
        let imageHtml = item.firstimage
            ? `<img src="${item.firstimage}" class="card-img-top card-img-custom" alt="${item.title}">`
            : `<img src="/images/no-image.jpg" class="card-img-top card-img-custom" alt="no image">`;

        html += `<div class="col">
            <a href="#" class="card-link" data-contentid="${item.contentid}" data-contenttypeid="${item.contenttypeid}" data-title="${item.title}">
                <div class="card h-100">
                    ${imageHtml}
                    <div class="card-body">
                        <span class="badge bg-success mb-2">추천 코스</span>
                        <h5 class="card-title">${item.title}</h5>
                        <p class="card-text">${item.addr1}</p>
                    </div>
                </div>
            </a>
        </div>`;
    });
    html += '</div>';
    document.getElementById("courseSection").innerHTML = html;
}


