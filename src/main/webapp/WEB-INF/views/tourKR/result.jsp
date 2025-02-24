<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>여행 일정 및 지도</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4a90e2;
            --secondary-color: #f39c12;
            --success-color: #2ecc71;
            --background-color: #f8f9fa;
            --card-shadow: 0 2px 8px rgba(0,0,0,0.1);
            --transition: all 0.3s ease;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--background-color);
        }

        .container {
            display: flex;
            height: 100vh;
        }

        .itinerary {
            width: 450px;
            background: white;
            box-shadow: var(--card-shadow);
            overflow-y: auto;
            transition: var(--transition);
        }

        .itinerary-header {
            position: sticky;
            top: 0;
            background: white;
            padding: 20px;
            border-bottom: 1px solid #eee;
            z-index: 10;
        }

        .itinerary-header h1 {
            margin: 0;
            color: var(--primary-color);
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .itinerary-header h1 i {
            font-size: 20px;
        }

        .day-section {
            margin: 20px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
        }

        .day-header {
            padding: 15px 20px;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            cursor: pointer;
            transition: var(--transition);
        }

        .day-header:hover {
            filter: brightness(85%);
        }

        .day-header.active {
            filter: brightness(115%);
        }

        .day-header .day-title {
            font-weight: 600;
            font-size: 16px;
        }

        .day-header .day-date {
            font-size: 14px;
            opacity: 0.9;
        }

        .place {
            padding: 15px;
            border-bottom: 1px solid #eee;
            display: flex;
            gap: 15px;
            transition: var(--transition);
            position: relative;
        }

        .place:hover {
            filter: brightness(95%);
        }

        .place-image {
            width: 120px;
            height: 90px;
            border-radius: 8px;
            object-fit: cover;
            box-shadow: var(--card-shadow);
            position: relative;
            z-index: 3; /* 이미지 앞으로 */
        }

        .place-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 5px;
            position: relative;
            z-index: 3; /* 텍스트 앞으로 */
        }

        .place-name {
            font-weight: 600;
            color: #333;
            font-size: 16px;
            margin: 0;
        }

        .place-address {
            color: #666;
            font-size: 14px;
            margin: 0;
        }

        .place-time {
            color: var(--primary-color);
            font-size: 13px;
            font-weight: 500;
        }

        .show-on-map {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            color: var(--primary-color);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            margin-top: 8px;
            transition: var(--transition);
        }

        .show-on-map:hover {
            color: var(--secondary-color);
            transform: translateX(5px);
        }

        .map-container {
            flex: 1;
            position: relative;
        }

        #map {
            width: 100%;
            height: 100%;
        }

        .loading {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(255,255,255,0.95);
            padding: 20px 40px;
            border-radius: 30px;
            box-shadow: var(--card-shadow);
            display: none;
            z-index: 1000;
        }

        .loading.active {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .loading i {
            color: var(--primary-color);
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            100% { transform: rotate(360deg); }
        }

        .place-connector {
            position: absolute;
            left: 60px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #e0e0e0;
            z-index: 1; /* 선을 뒤로 */
        }

        .place-number {
            position: absolute;
            left: 15px;
            top: 15px;
            width: 24px;
            height: 24px;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 600;
            z-index: 3; /* 번호 앞으로 */
        }

        /* 이미지 모달 스타일 */
        .image-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }

        .image-modal.active {
            display: flex;
        }

        .image-modal img {
            max-width: 90%;
            max-height: 90%;
            border-radius: 8px;
            box-shadow: var(--card-shadow);
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }

            .itinerary {
                width: 100%;
                height: 50%;
            }

            .map-container {
                height: 50%;
            }

            .place-image {
                width: 80px;
                height: 60px;
            }
        }
    </style>
</head>
<body>
<div class="loading">
    <i class="fas fa-spinner"></i>
    로딩중...
</div>

<!-- 이미지 모달 -->
<div class="image-modal" id="imageModal">
    <img id="modalImage" src="" alt="장소 이미지">
</div>

<div class="container">
    <div class="itinerary">
        <div class="itinerary-header">
            <h1><i class="fas fa-route"></i> 여행 일정</h1>
        </div>

        <c:forEach var="plan" items="${travelPlan}" varStatus="status">
            <div class="day-section" data-day="${status.index}">
                <div class="day-header" data-day="${status.index}">
                    <span class="day-title">DAY ${status.index + 1}</span>
                    <span class="day-date">${plan.date}</span>
                </div>
                <div class="day-places">
                    <c:forEach var="place" items="${plan.places}" varStatus="placeStatus">
                        <div class="place">
                            <div class="place-connector"></div>
                            <div class="place-number">${placeStatus.index + 1}</div>
                            <img class="place-image"
                                 src="${place.image != null && place.image != '' ? place.image : '/static/img/default-image.jpg'}"
                                 alt="${place.name}"
                                 onerror="this.src='/static/img/default-image.jpg'">
                            <div class="place-info">
                                <h3 class="place-name">${place.name}</h3>
                                <p class="place-address">${place.address}</p>
                                <span class="place-time">예상 방문 시간: ${place.visitTime != null ? place.visitTime : '미정'}</span>
                                <a href="javascript:void(0);" class="show-on-map"
                                   data-address="${place.address}"
                                   data-name="${place.name}"
                                   data-day="${status.index}"
                                   data-image="${place.image != null && place.image != '' ? place.image : '/static/img/default-image.jpg'}">
                                    <i class="fas fa-map-marker-alt"></i> 지도에서 보기
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:forEach>
    </div>

    <div class="map-container">
        <div id="map"></div>
    </div>
</div>

<script>
    const kakaoApiKey = '${kakaoJsKey}';
    const kakaoMapScript = document.createElement("script");
    kakaoMapScript.src = `https://dapi.kakao.com/v2/maps/sdk.js?appkey=d66111cc5c87422075d1e8b96a710bcd&autoload=false&libraries=services`;
    document.head.appendChild(kakaoMapScript);

    let map;
    let geocoder;
    const markersByDay = {};
    const polylinesByDay = {};
    let currentDay = null;
    let bounds;

    // 날짜별 색상 배열 정의
    const dayColors = [
        '#4a90e2', // DAY 1: 파란색
        '#e74c3c', // DAY 2: 빨간색
        '#2ecc71', // DAY 3: 초록색
        '#f39c12', // DAY 4: 주황색
        '#9b59b6', // DAY 5: 보라색
        '#34495e', // DAY 6: 남색
        '#e67e22'  // DAY 7: 진한 주황색
    ];

    const loading = document.querySelector('.loading');
    const showLoading = () => loading.classList.add('active');
    const hideLoading = () => loading.classList.remove('active');

    // 이미지 모달 관련 변수
    const imageModal = document.getElementById('imageModal');
    const modalImage = document.getElementById('modalImage');

    document.addEventListener('DOMContentLoaded', function() {
        kakaoMapScript.onload = function() {
            showLoading();
            kakao.maps.load(function() {
                initMap();
                applyDayColors(); // 색상 적용 함수 호출
                bindDayHeaderClicks();
                hideLoading();
            });
        };

        // 모달 닫기 이벤트
        imageModal.addEventListener('click', () => {
            imageModal.classList.remove('active');
        });
    });

    // 일정별 색상 적용 함수
    function applyDayColors() {
        document.querySelectorAll('.day-section').forEach((section, index) => {
            section.style.background = dayColors[index] + '20'; // 연한 색상
            section.querySelector('.day-header').style.background = dayColors[index]; // 진한 색상
            section.querySelectorAll('.place-number').forEach(num => {
                num.style.background = dayColors[index]; // 진한 색상
            });
        });
    }

    function initMap() {
        const container = document.getElementById('map');
        const options = {
            center: new kakao.maps.LatLng(37.5665, 126.9780),
            level: 7
        };

        map = new kakao.maps.Map(container, options);
        geocoder = new kakao.maps.services.Geocoder();
        bounds = new kakao.maps.LatLngBounds();

        map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
        map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);

        bindMapEvents();
        showAllPlacesOnMap();
    }

    function bindMapEvents() {
        const links = document.querySelectorAll('.show-on-map');
        if (links.length === 0) {
            console.warn("지도 링크(.show-on-map)가 존재하지 않습니다.");
            return;
        }
        links.forEach(link => {
            link.addEventListener('click', function() {
                showLoading();
                const address = this.getAttribute('data-address');
                const name = this.getAttribute('data-name');
                const day = this.getAttribute('data-day');
                const image = this.getAttribute('data-image');

                const headers = document.querySelectorAll('.day-header');
                headers.forEach(header => header.classList.remove('active'));
                const activeHeader = document.querySelector(`.day-header[data-day="${day}"]`);
                if (activeHeader) {
                    activeHeader.classList.add('active');
                } else {
                    console.warn(`day-header[data-day="${day}"]를 찾을 수 없습니다.`);
                }

                showPlaceOnMap(address, name, day, image);
                hideLoading();
            });
        });
    }

    function showPlaceOnMap(address, name, day, image) {
        geocoder.addressSearch(address, function(result, status) {
            if (status === kakao.maps.services.Status.OK && result.length > 0) {
                const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                bounds.extend(coords);

                const markerImage = new kakao.maps.MarkerImage(
                    image,
                    new kakao.maps.Size(35, 35),
                    { offset: new kakao.maps.Point(17, 35) }
                );

                const marker = new kakao.maps.Marker({
                    map: map,
                    position: coords,
                    title: name,
                    image: markerImage
                });

                kakao.maps.event.addListener(marker, 'click', function() {
                    modalImage.src = image;
                    imageModal.classList.add('active');
                });

                if (!markersByDay[day]) markersByDay[day] = [];
                markersByDay[day].push({marker});

                if (markersByDay[day].length > 1) {
                    const linePath = [];
                    markersByDay[day].forEach(({marker}) => {
                        linePath.push(marker.getPosition());
                    });

                    if (polylinesByDay[day]) {
                        polylinesByDay[day].forEach(polyline => polyline.setMap(null));
                        polylinesByDay[day] = [];
                    }

                    const polyline = new kakao.maps.Polyline({
                        path: linePath,
                        strokeWeight: 3,
                        strokeColor: dayColors[day] || '#4a90e2',
                        strokeOpacity: 0.7,
                        strokeStyle: 'solid'
                    });

                    if (!polylinesByDay[day]) polylinesByDay[day] = [];
                    polylinesByDay[day].push(polyline);
                    polyline.setMap(map);
                }

                map.setBounds(bounds);
            }
        });
    }

    function showAllPlacesOnMap() {
        showLoading();
        const promises = [];

        const links = document.querySelectorAll('.show-on-map');
        if (links.length === 0) {
            console.warn("지도에 표시할 장소가 없습니다.");
            hideLoading();
            return;
        }

        links.forEach(link => {
            const address = link.getAttribute('data-address');
            const name = link.getAttribute('data-name');
            const day = link.getAttribute('data-day');
            const image = link.getAttribute('data-image');

            promises.push(new Promise((resolve) => {
                showPlaceOnMap(address, name, day, image);
                resolve();
            }));
        });

        Promise.all(promises).then(() => {
            hideLoading();
        });
    }

    function bindDayHeaderClicks() {
        const headers = document.querySelectorAll('.day-header');
        if (headers.length === 0) {
            console.warn("날짜 헤더(.day-header)가 존재하지 않습니다.");
            return;
        }
        headers.forEach(header => {
            header.addEventListener('click', function() {
                const day = this.getAttribute('data-day');
                toggleDayView(day);
            });
        });
    }

    function toggleDayView(selectedDay) {
        const headers = document.querySelectorAll('.day-header');
        headers.forEach(header => header.classList.remove('active'));
        const activeHeader = document.querySelector(`.day-header[data-day="${selectedDay}"]`);
        if (activeHeader) {
            activeHeader.classList.add('active');
        } else {
            console.warn(`day-header[data-day="${selectedDay}"]를 찾을 수 없습니다.`);
            return;
        }

        Object.keys(markersByDay).forEach(day => {
            markersByDay[day].forEach(({marker}) => {
                marker.setMap(day === selectedDay ? map : null);
            });

            if (polylinesByDay[day]) {
                polylinesByDay[day].forEach(polyline => {
                    polyline.setMap(day === selectedDay ? map : null);
                });
            }
        });

        if (markersByDay[selectedDay] && markersByDay[selectedDay].length > 0) {
            const dayBounds = new kakao.maps.LatLngBounds();
            markersByDay[selectedDay].forEach(({marker}) => {
                dayBounds.extend(marker.getPosition());
            });
            map.setBounds(dayBounds);
        }

        document.querySelectorAll('.place').forEach(place => {
            const placeDay = place.querySelector('.show-on-map')?.getAttribute('data-day');
            if (placeDay) {
                place.style.opacity = placeDay === selectedDay ? '1' : '0.5';
            }
        });
    }

    window.addEventListener('load', () => {
        const firstDayHeader = document.querySelector('.day-header');
        if (firstDayHeader) {
            firstDayHeader.click();
        } else {
            console.warn("초기화할 첫 번째 날짜 헤더가 없습니다.");
        }
    });
</script>
</body>
</html>