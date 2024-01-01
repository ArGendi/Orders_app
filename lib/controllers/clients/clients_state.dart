abstract class ClientsState{}

class InitClientsState extends ClientsState{}
class GetClientsDataState extends ClientsState{}
class FilterClientsDataState extends ClientsState{}
class ClientDeletedState extends ClientsState{}
class UploadingState extends ClientsState{}
class SuccessUploadState extends ClientsState{}
class FailUploadState extends ClientsState{}
class DownloadingState extends ClientsState{}
class SuccessDownloadState extends ClientsState{}
class FailDownloadState extends ClientsState{}
class AddClientState extends ClientsState{}