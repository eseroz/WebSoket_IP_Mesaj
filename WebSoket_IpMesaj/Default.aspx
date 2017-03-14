<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebSoket_IP_Mesaj_Test.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>WEB Soket TEST</title>
</head>
<body>
    <script src="/scripts/jquery-1.6.4.min.js"></script>
    <script src="/scripts/jquery.signalR-2.2.1.min.js"></script>
    <script src="/signalr/hubs"></script>
    <script type="text/javascript">
        $(function () {

            var chat = $.connection.chatHub;
            $('#txtRumuz').val(prompt('İsminiz Nedir? :', ''));

            chat.client.differentName = function (name) {
                $('#txtRumuz').val(prompt($('#txtRumuz').val()+' ismi ile giriş yapmış başka biri var lütfen farklı bir isim yazın:', ''));
                chat.server.notify($('#txtRumuz').val(), $.connection.hub.id);
            };

            chat.client.online = function (name) {
                if (name == $('#txtRumuz').val())
                    $('#divOnlineKullanicilar').append('<div class="border" style="color:red">Siz: ' + name + '</div>');
                else {
                    $('#divOnlineKullanicilar').append('<div class="border">' + name + '</div>');
                    $("#cboOnlineKullanicilar").append('<option value="' + name + '">' + name + '</option>');
                }
            };

            chat.client.enters = function (name) {
                $('#divMesajAlani').append('<div class="border"><i>' + name + ' odaya katıldı.</i></div>');
                $("#cboOnlineKullanicilar").append('<option value="' + name + '">' + name + '</option>');
                $('#divOnlineKullanicilar').append('<div class="border">' + name + '</div>');
            };

            chat.client.broadcastMessage = function (name, message) {
                $('#divMesajAlani').append('<div class="border"><span style="color:blue">' + name + '</span>: ' + message + '</div>');
            };

            chat.client.disconnected = function (name) {
                $('#divMesajAlani').append('<div class="border"><i>' + name + ' odadan ayrıldı</i></div>');
                $('#divOnlineKullanicilar div').remove(":contains('" + name + "')");
                $("#cboOnlineKullanicilar option").remove(":contains('" + name + "')");
            }

            $.connection.hub.start().done(function () {
                chat.server.notify($('#txtRumuz').val(), $.connection.hub.id);
                $('#btnMesajGonder').click(function () {
                    if ($("#cboOnlineKullanicilar").val() == "All") {
                        chat.server.send($('#txtRumuz').val(), $('#txtMesaj').val());
                    }
                    else {
                        chat.server.sendToSpecific($('#txtRumuz').val(), $('#txtMesaj').val(), $("#cboOnlineKullanicilar").val());
                    }
                    $('#txtMesaj').val('').focus();
                });
            });

            $("#btnTemizle").click(function () {
                $("#divMesajAlani").empty();
            });

        });
    </script>
    <input type="hidden" id="txtRumuz" />
    <div style="height: 80%;">
        <div id="divMesajAlani" style="width: 80%; float: left;"></div>
        <div id="divOnlineKullanicilar" style="width: 19%; float: right; border-left: solid red 2px; height: 100%;">
            <div style="font-size: 20px; border-bottom: double">Bağlı Kullanıcı Listesi</div>
        </div>
    </div>
    <div style="height: 19%;"">
        <div style="float: left; height: 90%; top: 10%; position: relative;">
            <textarea spellcheck="true" id="txtMesaj" style="width: 625px; height: 80%"></textarea>
        </div>
        <div style="position: relative; top: 30%; float: left;">
            <input type="button" id="btnMesajGonder" value="Gönder" />
               <input type="button" id="btnTemizle" value="Odayı Temizle" />
        </div>
        <div style="position: relative; top: 30%; float: left;">
            <select id="cboOnlineKullanicilar">
                <option value="All">Tüm Kullanıcılar</option>
            </select>
        </div>
    </div>
</body>
</html>