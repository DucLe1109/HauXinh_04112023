// ignore_for_file: constant_identifier_names

enum FirebaseFirestoreException {
  ABORTED('aborted'),
  ALREADY_EXISTS('already-exists'),
  CANCELLED('cancelled'),
  DATA_LOSS('data-loss'),
  DEADLINE_EXCEEDED('deadline-exceeded'),
  FAILED_PRECONDITION('failed-precondition'),
  INTERNAL('internal'),
  INVALID_ARGUMENT('invalid-argument '),
  NOT_FOUND('not-found'),
  OK('ok'),
  OUT_OF_RANGE('out-of-range'),
  PERMISSION_DENIED('permission-denied'),
  RESOURCE_EXHAUSTED('resource-exhausted'),
  UNAUTHENTICATED('unauthenticated'),
  UNAVAILABLE('unavailable'),
  UNIMPLEMENTED('unimplemented'),
  UNKNOWN('unknown');

  final String code;

  const FirebaseFirestoreException(this.code);
}
