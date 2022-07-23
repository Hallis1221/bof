import 'package:graphql/client.dart';

final GraphQLClient client = GraphQLClient(
  cache: GraphQLCache(),
  link: HttpLink("https://api.bucketofcrabs.net/graphql"),
);
