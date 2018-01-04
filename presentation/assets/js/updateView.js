function getVideos() {
    var query = document.getElementById('search_input').value
    $.post("search", {
            search_name: query
        })
        .always(function(data) {
            $('#videoContent').empty();
            data = JSON.parse(data);
            for (i=0; i< data.video_id.length; i++) {
                addVideoView(data.video_id[i]);
            }
            $('html, body').animate({
                scrollTop: ($('#myTab').offset().top - 80)
            },500);
            fixVideoPlayBug();
        });
    return false;
}

function uploadPic(){
    $.ajax({
        url: '/uploadFile',
        type: 'POST',
        cache: false,
        data: new FormData($('#new-file-form')[0]),
        processData: false,
        contentType: false
    }).always(function(data) {
        $('#newFileModal').click();
        $('#videoContent').empty();
        data = JSON.parse(data);
        for (i=0; i< data.video_id.length; i++) {
            addVideoView(data.video_id[i]);
        }
        $('html, body').animate({
            scrollTop: ($('#myTab').offset().top - 80)
        },500);
        fixVideoPlayBug();
    });

    return false;
}

function addVideoView(videoID) {
    var content = "<div class=\"col-sm-4\" data-target=\"#videoModal\" data-toggle=\"modal\" data-video=\"https://www.youtube.com/embed/" + videoID + "\" id=\"cardDiv\" style=\"cursor: pointer;\"><div class=\"card\" style=\"width:20rem;margin-top:3%;\"><div class=\"card-body\" style=\"background-image:url('/images/card-bg.jpg');background-repeat: no-repeat;background-size:100% 100%;\"><iframe class=\"youtube-player\" frameborder=\"0\" height=\"10%\" src=\"http://www.youtube.com/embed/" + videoID + "\" style=\"pointer-events: none;\" type=\"text/html\" width=\"100%\"></iframe><br></div><div class=\"card-footer\" style=\"background-color:#fff;\"><a class=\"btn btn-primary video\" data-target=\"#videoModal\" data-toggle=\"modal\" data-video=\"https://www.youtube.com/embed/" + videoID + "\">    Go Watch Video!</a></div></div></div>";
    $(content).appendTo('#videoContent');
}

function fixVideoPlayBug(){
    $("#cardDiv").click(function() {
        var theModal = $(this).data("target"),
            videoSRC = $(this).attr("data-video"),
            videoSRCauto = videoSRC + "?modestbranding=1&rel=0&controls=1&showinfo=0&html5=1&autoplay=1";
        $(theModal + ' iframe').attr('src', videoSRCauto);
        $(theModal + ' button.close').click(function() {
            $(theModal + ' iframe').attr('src', videoSRC);
        });
    });
}

$(document).ready(function() {
    $(document).scroll(function() {
        scroll_start = $(this).scrollTop();
        if (scroll_start > ($(document).height()) / 2 - 150) {
            $('#homepage').css('color', '#000');
            $('#About').css('color', '#000');
        } else {
            $('#homepage').css('color', '#fff');
            $('#About').css('color', '#fff');
        }
    });

    $("#Back2Top").click(function() {
        $("html, body").animate({
            scrollTop: 0
        }, 1000);
    });
});
