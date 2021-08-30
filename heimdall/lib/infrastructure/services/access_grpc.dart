import 'package:chainmetric/infrastructure/services/access_grpc.pbgrpc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:grpc/grpc.dart' as grpc;

class AccessService extends AccessServiceClient {
  final String organization;

  AccessService(this.organization,
      {grpc.ClientChannel? channel, List<int>? certificate})
      : super(channel ??
      grpc.ClientChannel("identity.$organization.org.${GlobalConfiguration().getValue("grpc_domain")}",
          options: grpc.ChannelOptions(
              credentials: grpc.ChannelCredentials.secure(
                  certificates: certificate))));
}
