import 'package:my_clean/interfaces/ToJsonInterface.dart';
import 'package:my_clean/models/booking.dart';
import 'package:my_clean/models/frequence.dart';
import 'package:my_clean/models/services.dart';
import 'package:my_clean/models/user.dart';

class DataResponse<T> {
    String? context;
    String? id;
    String? type;
    List<T>? hydraMember;
    int? hydraTotalItems;

    DataResponse({this.context, this.id, this.type, this.hydraMember, this.hydraTotalItems});

    factory DataResponse.fromJson(Map<String, dynamic> json) {
        return DataResponse(
            context: json['@context'],
            id: json['@id'],
            type: json['@type'],
            hydraMember: json['hydra:member'] != null ? (json['hydra:member'] as List).map<T>((i) {
                switch(T){
                    case Services:
                        return Services.fromJson(i) as T;
                    case Frequence:
                        return Frequence.fromJson(i) as T;
                    case User:
                        return User.fromJson(i) as T;
                    case Booking:
                        return Booking.fromJson(i) as T;
                    default:
                        return null as T;
                }

            }).toList() : null,
            hydraTotalItems: json['hydra:totalItems'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['@context'] = this.context;
        data['@id'] = this.id;
        data['@type'] = this.type;
        data['hydra:totalItems'] = this.hydraTotalItems;
        if (this.hydraMember != null) {
            data['hydra:member'] = this.hydraMember?.map((v) => (v as ToJsonInterface).toJson()).toList();
        }
        return data;
    }
}