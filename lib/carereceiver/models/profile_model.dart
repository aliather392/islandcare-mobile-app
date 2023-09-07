// To parse this JSON data, do
//
//     final profileReceiverModel = profileReceiverModelFromJson(jsonString);

import 'dart:convert';

ProfileReceiverModel profileReceiverModelFromJson(String str) => ProfileReceiverModel.fromJson(json.decode(str));

String profileReceiverModelToJson(ProfileReceiverModel data) => json.encode(data.toJson());

class ProfileReceiverModel {
    ProfileReceiverModel({
        this.folderPath,
        this.data,
    });

    String? folderPath;
    List<Datum>? data;

    factory ProfileReceiverModel.fromJson(Map<String, dynamic> json) => ProfileReceiverModel(
        folderPath: json["folder_path"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "folder_path": folderPath,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.emailVerifiedAt,
        this.providerId,
        this.avatar,
        this.role,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.userdetailprovider,
        this.userdetail,
    });

    int? id;
    String? firstName;
    String? lastName;
    String? email;
    String? phone;
    DateTime? emailVerifiedAt;
    dynamic providerId;
    String? avatar;
    int? role;
    int? status;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;
    dynamic userdetailprovider;
    Userdetail? userdetail;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
        providerId: json["provider_id"],
        avatar: json["avatar"],
        role: json["role"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        userdetailprovider: json["userdetailprovider"],
        userdetail: json["userdetail"] == null ? null : Userdetail.fromJson(json["userdetail"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "provider_id": providerId,
        "avatar": avatar,
        "role": role,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "userdetailprovider": userdetailprovider,
        "userdetail": userdetail?.toJson(),
    };
}

class Userdetail {
    Userdetail({
        this.id,
        this.userId,
        this.gender,
        this.dob,
        this.servicesRequired,
        this.zip,
        this.address,
        this.userInfo,
        this.createdAt,
        this.updatedAt,
        this.service,
    });

    int? id;
    int? userId;
    int? gender;
    String? dob;
    String? servicesRequired;
    String? zip;
    String? address;
    String? userInfo;
    DateTime? createdAt;
    DateTime? updatedAt;
    Service? service;

    factory Userdetail.fromJson(Map<String, dynamic> json) => Userdetail(
        id: json["id"],
        userId: json["user_id"],
        gender: json["gender"],
        dob: json["dob"],
        servicesRequired: json["services_required"],
        zip: json["zip"],
        address: json["address"],
        userInfo: json["user_info"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "gender": gender,
        "dob": dob,
        "services_required": servicesRequired,
        "zip": zip,
        "address": address,
        "user_info": userInfo,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "service": service?.toJson(),
    };
}

class Service {
    Service({
        this.id,
        this.name,
        this.image,
        this.description,
        this.isActive,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
    });

    int? id;
    String? name;
    String? image;
    String? description;
    int? isActive;
    DateTime? deletedAt;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        isActive: json["is_active"],
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "is_active": isActive,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
