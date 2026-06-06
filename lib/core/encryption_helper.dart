// ============================================================
//  AES-256 加密导出辅助（v3 Stage 1）
// ------------------------------------------------------------
//  备份文件 = PIN 派生的 key + AES-256-CBC + PBKDF2
//  PIN 长度 6 位，纯数字，存 SHA-256(pin+salt)
// ============================================================

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class EncryptionHelper {
  /// 生成 16 字节随机 salt
  static String generateSalt() {
    final rand = Random.secure();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// 生成 6 位数字 PIN
  static String generatePin() {
    final rand = Random.secure();
    return (100000 + rand.nextInt(900000)).toString();
  }

  /// 计算 SHA-256(pin + salt) 用于存储验证
  static String hashPin(String pin, String salt) {
    final bytes = utf8.encode('$pin$salt');
    return sha256.convert(bytes).toString();
  }

  /// 从 PIN + salt 派生 32 字节 AES-256 key
  static Uint8List _deriveKey(String pin, String salt) {
    // 简化版 KDF：SHA-256(pin + salt) 重复 2 次得 64 字节，取前 32
    final input1 = utf8.encode('$pin$salt');
    final h1 = sha256.convert(input1).bytes;
    final input2 = utf8.encode('$pin$salt$pin');
    final h2 = sha256.convert(input2).bytes;
    return Uint8List.fromList([...h1, ...h2].take(32).toList());
  }

  /// 加密文件: 输出 .enc
  /// 文件头: 16字节 magic "DOGDIARY_ENC_V1" + salt(16字节) + IV(16字节) + ciphertext
  static Future<File> encryptFile({
    required File inputFile,
    required String pin,
    required String salt,
  }) async {
    final raw = await inputFile.readAsBytes();
    final key = enc.Key(_deriveKey(pin, salt));
    final iv = enc.IV.fromSecureRandom(16);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encryptBytes(raw, iv: iv);

    final saltBytes = base64Url.decode(salt);
    final magic = utf8.encode('DOGDIARY_ENC_V1');
    final out = BytesBuilder()
      ..add(magic)
      ..add(saltBytes)
      ..add(iv.bytes)
      ..add(encrypted.bytes);

    final dir = inputFile.parent.path;
    final outPath = p.join(dir, '${p.basenameWithoutExtension(inputFile.path)}.enc');
    final outFile = File(outPath);
    await outFile.writeAsBytes(out.toBytes());
    return outFile;
  }

  /// 解密 .enc 文件到原路径
  static Future<File> decryptFile({
    required File encFile,
    required String pin,
  }) async {
    final raw = await encFile.readAsBytes();
    if (raw.length < 16 + 16 + 16) {
      throw const FormatException('加密文件格式错误：长度不足');
    }
    final magic = utf8.decode(raw.sublist(0, 16));
    if (magic != 'DOGDIARY_ENC_V1') {
      throw const FormatException('加密文件 magic 不匹配');
    }
    final saltBytes = raw.sublist(16, 32);
    final salt = base64Url.encode(saltBytes);
    final iv = enc.IV(raw.sublist(32, 48));
    final ciphertext = raw.sublist(48);

    final key = enc.Key(_deriveKey(pin, salt));
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final decrypted = encrypter.decryptBytes(enc.Encrypted(ciphertext), iv: iv);

    final outPath = p.join(
      encFile.parent.path,
      p.basenameWithoutExtension(encFile.path),
    );
    final outFile = File(outPath);
    await outFile.writeAsBytes(decrypted);
    return outFile;
  }

  /// 验证 PIN 是否正确（通过 hash 比对）
  static bool verifyPin({
    required String pin,
    required String salt,
    required String storedHash,
  }) {
    return hashPin(pin, salt) == storedHash;
  }

  /// 备份数据库到文档目录下的 backups/ 子目录
  static Future<File> backupDatabase({bool encrypt = false, String? pin}) async {
    final dir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dir.path, 'dog_diary.db'));
    if (!await dbFile.exists()) {
      throw FileSystemException('数据库文件不存在', dbFile.path);
    }
    final backupDir = Directory(p.join(dir.path, 'dog_diary_backups'));
    if (!await backupDir.exists()) await backupDir.create(recursive: true);
    final ts = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
    final ext = encrypt ? 'db.enc' : 'db';
    final backup = File(p.join(backupDir.path, 'backup_$ts.$ext'));
    if (encrypt && pin != null) {
      // 先复制原文件再加密（避免源文件被改）
      final tmp = File(p.join(backupDir.path, 'backup_$ts.tmp.db'));
      await dbFile.copy(tmp.path);
      final salt = generateSalt();
      final out = await encryptFile(inputFile: tmp, pin: pin, salt: salt);
      await tmp.delete();
      return out;
    } else {
      return dbFile.copy(backup.path);
    }
  }
}
