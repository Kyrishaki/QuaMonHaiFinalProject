(function ($) {
    "use strict";

    // Spinner
    var spinner = function () {
        setTimeout(function () {
            if ($('#spinner').length > 0) {
                $('#spinner').removeClass('show');
            }
        }, 1);
    };
    spinner();
    
    
    // Initiate the wowjs
    new WOW().init();


    // Fixed Navbar
    $(window).scroll(function () {
        if ($(window).width() < 992) {
            if ($(this).scrollTop() > 45) {
                $('.fixed-top').addClass('bg-white shadow');
            } else {
                $('.fixed-top').removeClass('bg-white shadow');
            }
        } else {
            if ($(this).scrollTop() > 45) {
                $('.fixed-top').addClass('bg-white shadow').css('top', -45);
            } else {
                $('.fixed-top').removeClass('bg-white shadow').css('top', 0);
            }
        }
    });
    
    
    // Back to top button
    var backToTopBtn = document.querySelector('.back-to-top');
    var isBackToTopVisible = false;

    $(window).scroll(function () {
        if ($(this).scrollTop() > 300) {
            if (!isBackToTopVisible) {
                isBackToTopVisible = true;
                if (backToTopBtn) {
                    backToTopBtn.style.display = 'flex';
                    anime({
                        targets: backToTopBtn,
                        opacity: [0, 1],
                        scale: [0.5, 1],
                        translateY: [20, 0],
                        duration: 500,
                        easing: 'easeOutBack'
                    });
                }
            }
        } else {
            if (isBackToTopVisible) {
                isBackToTopVisible = false;
                if (backToTopBtn) {
                    anime({
                        targets: backToTopBtn,
                        opacity: [1, 0],
                        scale: [1, 0.5],
                        translateY: [0, 20],
                        duration: 400,
                        easing: 'easeInQuad',
                        complete: function() {
                            if (!isBackToTopVisible && backToTopBtn) {
                                backToTopBtn.style.display = 'none';
                            }
                        }
                    });
                }
            }
        }
    });

    if (backToTopBtn) {
        // Hiệu ứng hover bằng anime.js
        backToTopBtn.addEventListener('mouseenter', function() {
            if (isBackToTopVisible) {
                anime({
                    targets: backToTopBtn,
                    scale: 1.15,
                    rotate: '1turn',
                    duration: 500,
                    easing: 'easeOutQuad'
                });
            }
        });

        backToTopBtn.addEventListener('mouseleave', function() {
            if (isBackToTopVisible) {
                anime({
                    targets: backToTopBtn,
                    scale: 1.0,
                    rotate: '0turn',
                    duration: 500,
                    easing: 'easeOutQuad'
                });
            }
        });

        // Click cuộn lên đầu trang bằng anime.js
        backToTopBtn.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Hiệu ứng nhấp nháy/phóng to thu nhỏ khi click
            anime({
                targets: backToTopBtn,
                scale: [1, 0.8, 1.25, 1],
                duration: 500,
                easing: 'easeInOutQuad'
            });

            // Cuộn mượt lên đầu trang
            var scrollElement = window.document.scrollingElement || window.document.documentElement || window.document.body;
            anime({
                targets: scrollElement,
                scrollTop: 0,
                duration: 1000,
                easing: 'easeInOutExpo'
            });
            
            return false;
        });
    }


    // Testimonials carousel
    $(".testimonial-carousel").owlCarousel({
        autoplay: true,
        smartSpeed: 1000,
        margin: 25,
        loop: true,
        center: true,
        dots: false,
        nav: true,
        navText : [
            '<i class="bi bi-chevron-left"></i>',
            '<i class="bi bi-chevron-right"></i>'
        ],
        responsive: {
            0:{
                items:1
            },
            768:{
                items:2
            },
            992:{
                items:3
            }
        }
    });

    
})(jQuery);

