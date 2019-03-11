$(document).ready(function () {
  $("#micropost_picture").bind("change", function () {
    var size_in_megabytes = this.files[0].size / 1024 / 1024;
    var max_size_megabytes = $("#micropost_picture").data("max-size-megabytes");
    if (size_in_megabytes > max_size_megabytes) {
      alert(
        I18n.t("picture_too_large_warning", {
          size_megabytes: max_size_megabytes
        })
      );
    }
  });
});
