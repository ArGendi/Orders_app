abstract class OrderState{}

class InitOrderState extends OrderState{}
class AddDeadlineOrderState extends OrderState{}
class SuccessOrderState extends OrderState{}
class FailOrderState extends OrderState{}
class LoadingOrderState extends OrderState{}
class OrderDoneState extends OrderState{}
class ImageUplaodedState extends OrderState{}
class LoadingUploadOrderState extends OrderState{}
class DoneUploadOrderState extends OrderState{}