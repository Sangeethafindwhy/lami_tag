// ignore_for_file: unused_element

class AppBaseState {
  final bool busy;
  final bool initialize;
  final bool idle;
  final bool error;
  final bool uploading;
  final bool loadingMoreData;
  final bool noData;

  AppBaseState._()
      : busy = false,
        initialize = false,
        idle = true,
        error = false,
        uploading = false,
        loadingMoreData = false,
  noData = false;


  AppBaseState.idle()
      : busy = false,
        initialize = false,
        idle = true,
        error = false,
        uploading = false,
        loadingMoreData = false, noData = false;

  AppBaseState.busy()
      : busy = true,
        initialize = false,
        idle = false,
        error = false,
        uploading = false,
        loadingMoreData = false, noData = false;

  AppBaseState.initialize()
      : busy = false,
        initialize = true,
        idle = false,
        error = false,
        uploading = false,
        loadingMoreData = false, noData = false;

  AppBaseState.error()
      : busy = false,
        initialize = false,
        idle = false,
        error = true,
        uploading = false,
        loadingMoreData = false, noData = false;

  AppBaseState.uploading()
      : busy = false,
        initialize = false,
        idle = false,
        error = false,
        uploading = true,
        loadingMoreData = false, noData = false;

  AppBaseState.loadingMoreData()
      : busy = false,
        initialize = false,
        idle = false,
        error = false,
        uploading = false,
        loadingMoreData = true, noData = false;

  AppBaseState.noData()
      : busy = false,
        initialize = false,
        idle = false,
        error = false,
        uploading = false,
        loadingMoreData = false, noData = true;

  @override
  String toString() {
    return 'State: init: $initialize, busy: $busy, idle: $idle, uploading: $uploading, loadingmoredata: $loadingMoreData';
  }
}
