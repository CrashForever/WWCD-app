function getVideos() {
    NProgress.start();
    var query = document.getElementById('search_input').value
    $.post("search", {
            search_name: query
        })
        .always(function(data) {
            $('#videoContent').empty();
            data = JSON.parse(data);
            video_json = JSON.parse(data.video_json);
            recipe_json = JSON.parse(data.recipe_json);
            for (i=0; i< video_json.video_id.length; i++) {
                addVideoView(video_json.video_id[i]);
            }
            for (i=0; i< recipe_json.label.length; i++) {
                addRecipeView(recipe_json.label[i], recipe_json.url[i], recipe_json.image[i]);
            }
            fixVideoPlayBug();
            progressDone();
        });
    return false;
}

function uploadPic(){
    NProgress.start();
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
        video_json = JSON.parse(data.video_json);
        recipe_json = JSON.parse(data.recipe_json);
        for (i=0; i< video_json.video_id.length; i++) {
            addVideoView(video_json.video_id[i]);
        }
        for (i=0; i< recipe_json.label.length; i++) {
            addRecipeView(recipe_json.label[i], recipe_json.url[i], recipe_json.image[i]);
        }
        fixVideoPlayBug();
        progressDone();
    });

    return false;
}

function uploadCameraPhoto(){
    NProgress.start();
    $.ajax({
        url: '/camera_photo_upload',
        type: 'POST',
        cache: false,
        data: new FormData($('#new-file-form-camera')[0]),
        processData: false,
        contentType: false
    }).always(function(data) {
        $('#newFileModal').click();
        $('#videoContent').empty();
        data = JSON.parse(data);
        video_json = JSON.parse(data.video_json);
        recipe_json = JSON.parse(data.recipe_json);
        for (i=0; i< video_json.video_id.length; i++) {
            addVideoView(video_json.video_id[i]);
        }
        for (i=0; i< recipe_json.label.length; i++) {
            addRecipeView(recipe_json.label[i], recipe_json.url[i], recipe_json.image[i]);
        }
        fixVideoPlayBug();
        progressDone();
    });

    return false;
}

function addVideoView(videoID) {
    $("#section").fadeIn(500);
    var content = "<div class=\"col-sm-4\" data-target=\"#videoModal\" data-toggle=\"modal\" data-video=\"https://www.youtube.com/embed/" + videoID + "\" id=\"cardDiv\" style=\"cursor: pointer;\"><div class=\"card\" style=\"width:95%;margin-top:3%;\"><div class=\"card-body\" style=\"background-image:url('/images/card-bg.jpg');background-repeat: no-repeat;background-size:100% 100%;\"><iframe class=\"youtube-player\" frameborder=\"0\" height=\"10%\" src=\"http://www.youtube.com/embed/" + videoID + "\" style=\"pointer-events: none;\" type=\"text/html\" width=\"100%\"></iframe><br></div><div class=\"card-footer\" style=\"background-color:#fff;\"><a class=\"btn btn-primary video\" data-target=\"#videoModal\" data-toggle=\"modal\" data-video=\"https://www.youtube.com/embed/" + videoID + "\">    Go Watch Video!</a></div></div></div>";
    $(content).appendTo('#videoContent');
}

function addRecipeView(label, website_url, image_url) {
    $("#section").fadeIn(500);
    var content = "<div class=\"col-sm-4\" id=\"cardDiv\" onclick=\"window.open('"+ website_url +"','_blank');\" style=\"cursor: pointer;\"><div class=\"card\" style=\"width: 20rem;margin-top:3%;\"><div class=\"card-body\" style=\"background-image:url('/images/card-bg.jpg');background-repeat: no-repeat;background-size:100% 100%;\"><img src=\""+image_url+"\" width=\"100%\">;</div><div class=\"card-footer\" style=\"background-color:#fff; color:black; text-align:center\">"+ label +"</div></div></div>";
    $(content).appendTo('#recipeContent');
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

function progressDone(){
    setTimeout(function() {
        NProgress.done();
        $('html, body').animate({
            scrollTop: ($('#myTab').offset().top - 80)
        },500);
    }, 3500);
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
