const pre =
    "https://secure.seguroslafise.com.ni/seviciosSeguronetCore_PRE/api/";
const pro =
    "https://seguronetnlb.seguroslafise.com.ni/seviciosSeguronetCore/api/";

const local = "http://lexaguilar-001-site1.gtempurl.com/api/";

const String PATH = pro;

const String PATH_LOGIN = "${PATH}account/login";
String getTramite(idtramite) {
  return "${PATH}tramite/get/$idtramite";
}

String getUploadFiles(tramiteId, username) {
  return "${PATH}file/post/tramite/$tramiteId/username/$username";
}

String changePassUrl(String username) {
  return "${PATH}changepass/$username";
}
