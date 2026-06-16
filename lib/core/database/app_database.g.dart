// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BookmarksTable extends Bookmarks with TableInfo<$BookmarksTable, Bookmark>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$BookmarksTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _urlMeta = const VerificationMeta('url');
@override
late final GeneratedColumn<String> url = GeneratedColumn<String>('url', aliasedName, false, additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1,), type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _titleMeta = const VerificationMeta('title');
@override
late final GeneratedColumn<String> title = GeneratedColumn<String>('title', aliasedName, false, additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1,), type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _descriptionMeta = const VerificationMeta('description');
@override
late final GeneratedColumn<String> description = GeneratedColumn<String>('description', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta('thumbnailUrl');
@override
late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>('thumbnail_url', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _faviconUrlMeta = const VerificationMeta('faviconUrl');
@override
late final GeneratedColumn<String> faviconUrl = GeneratedColumn<String>('favicon_url', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
@override
late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _notesMeta = const VerificationMeta('notes');
@override
late final GeneratedColumn<String> notes = GeneratedColumn<String>('notes', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _categoryMeta = const VerificationMeta('category');
@override
late final GeneratedColumn<String> category = GeneratedColumn<String>('category', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _folderIdMeta = const VerificationMeta('folderId');
@override
late final GeneratedColumn<int> folderId = GeneratedColumn<int>('folder_id', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
static const VerificationMeta _isFavoriteMeta = const VerificationMeta('isFavorite');
@override
late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>('is_favorite', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'), defaultValue: const Constant(false));
static const VerificationMeta _isArchivedMeta = const VerificationMeta('isArchived');
@override
late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>('is_archived', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'), defaultValue: const Constant(false));
@override
List<GeneratedColumn> get $columns => [id, url, title, description, thumbnailUrl, faviconUrl, createdAt, updatedAt, notes, category, folderId, isFavorite, isArchived];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'bookmarks';
@override
VerificationContext validateIntegrity(Insertable<Bookmark> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));}if (data.containsKey('url')) {
context.handle(_urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));} else if (isInserting) {
context.missing(_urlMeta);
}
if (data.containsKey('title')) {
context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));} else if (isInserting) {
context.missing(_titleMeta);
}
if (data.containsKey('description')) {
context.handle(_descriptionMeta, description.isAcceptableOrUnknown(data['description']!, _descriptionMeta));}if (data.containsKey('thumbnail_url')) {
context.handle(_thumbnailUrlMeta, thumbnailUrl.isAcceptableOrUnknown(data['thumbnail_url']!, _thumbnailUrlMeta));}if (data.containsKey('favicon_url')) {
context.handle(_faviconUrlMeta, faviconUrl.isAcceptableOrUnknown(data['favicon_url']!, _faviconUrlMeta));}if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));} else if (isInserting) {
context.missing(_createdAtMeta);
}
if (data.containsKey('updated_at')) {
context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));} else if (isInserting) {
context.missing(_updatedAtMeta);
}
if (data.containsKey('notes')) {
context.handle(_notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));}if (data.containsKey('category')) {
context.handle(_categoryMeta, category.isAcceptableOrUnknown(data['category']!, _categoryMeta));}if (data.containsKey('folder_id')) {
context.handle(_folderIdMeta, folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta));}if (data.containsKey('is_favorite')) {
context.handle(_isFavoriteMeta, isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta));}if (data.containsKey('is_archived')) {
context.handle(_isArchivedMeta, isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta));}return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {id};
@override Bookmark map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return Bookmark(id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!, url: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}url'])!, title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!, description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description']), thumbnailUrl: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}thumbnail_url']), faviconUrl: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}favicon_url']), createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!, notes: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}notes']), category: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category']), folderId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}folder_id']), isFavorite: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!, isArchived: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!, );
}
@override
$BookmarksTable createAlias(String alias) {
return $BookmarksTable(attachedDatabase, alias);}}class Bookmark extends DataClass implements Insertable<Bookmark> 
{
final int id;
final String url;
final String title;
final String? description;
final String? thumbnailUrl;
final String? faviconUrl;
final DateTime createdAt;
final DateTime updatedAt;
final String? notes;
final String? category;
final int? folderId;
final bool isFavorite;
final bool isArchived;
const Bookmark({required this.id, required this.url, required this.title, this.description, this.thumbnailUrl, this.faviconUrl, required this.createdAt, required this.updatedAt, this.notes, this.category, this.folderId, required this.isFavorite, required this.isArchived});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<int>(id);
map['url'] = Variable<String>(url);
map['title'] = Variable<String>(title);
if (!nullToAbsent || description != null){map['description'] = Variable<String>(description);
}if (!nullToAbsent || thumbnailUrl != null){map['thumbnail_url'] = Variable<String>(thumbnailUrl);
}if (!nullToAbsent || faviconUrl != null){map['favicon_url'] = Variable<String>(faviconUrl);
}map['created_at'] = Variable<DateTime>(createdAt);
map['updated_at'] = Variable<DateTime>(updatedAt);
if (!nullToAbsent || notes != null){map['notes'] = Variable<String>(notes);
}if (!nullToAbsent || category != null){map['category'] = Variable<String>(category);
}if (!nullToAbsent || folderId != null){map['folder_id'] = Variable<int>(folderId);
}map['is_favorite'] = Variable<bool>(isFavorite);
map['is_archived'] = Variable<bool>(isArchived);
return map; 
}
BookmarksCompanion toCompanion(bool nullToAbsent) {
return BookmarksCompanion(id: Value(id),url: Value(url),title: Value(title),description: description == null && nullToAbsent ? const Value.absent() : Value(description),thumbnailUrl: thumbnailUrl == null && nullToAbsent ? const Value.absent() : Value(thumbnailUrl),faviconUrl: faviconUrl == null && nullToAbsent ? const Value.absent() : Value(faviconUrl),createdAt: Value(createdAt),updatedAt: Value(updatedAt),notes: notes == null && nullToAbsent ? const Value.absent() : Value(notes),category: category == null && nullToAbsent ? const Value.absent() : Value(category),folderId: folderId == null && nullToAbsent ? const Value.absent() : Value(folderId),isFavorite: Value(isFavorite),isArchived: Value(isArchived),);
}
factory Bookmark.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return Bookmark(id: serializer.fromJson<int>(json['id']),url: serializer.fromJson<String>(json['url']),title: serializer.fromJson<String>(json['title']),description: serializer.fromJson<String?>(json['description']),thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),faviconUrl: serializer.fromJson<String?>(json['faviconUrl']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),notes: serializer.fromJson<String?>(json['notes']),category: serializer.fromJson<String?>(json['category']),folderId: serializer.fromJson<int?>(json['folderId']),isFavorite: serializer.fromJson<bool>(json['isFavorite']),isArchived: serializer.fromJson<bool>(json['isArchived']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<int>(id),'url': serializer.toJson<String>(url),'title': serializer.toJson<String>(title),'description': serializer.toJson<String?>(description),'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),'faviconUrl': serializer.toJson<String?>(faviconUrl),'createdAt': serializer.toJson<DateTime>(createdAt),'updatedAt': serializer.toJson<DateTime>(updatedAt),'notes': serializer.toJson<String?>(notes),'category': serializer.toJson<String?>(category),'folderId': serializer.toJson<int?>(folderId),'isFavorite': serializer.toJson<bool>(isFavorite),'isArchived': serializer.toJson<bool>(isArchived),};}Bookmark copyWith({int? id,String? url,String? title,Value<String?> description = const Value.absent(),Value<String?> thumbnailUrl = const Value.absent(),Value<String?> faviconUrl = const Value.absent(),DateTime? createdAt,DateTime? updatedAt,Value<String?> notes = const Value.absent(),Value<String?> category = const Value.absent(),Value<int?> folderId = const Value.absent(),bool? isFavorite,bool? isArchived}) => Bookmark(id: id ?? this.id,url: url ?? this.url,title: title ?? this.title,description: description.present ? description.value : this.description,thumbnailUrl: thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,faviconUrl: faviconUrl.present ? faviconUrl.value : this.faviconUrl,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,notes: notes.present ? notes.value : this.notes,category: category.present ? category.value : this.category,folderId: folderId.present ? folderId.value : this.folderId,isFavorite: isFavorite ?? this.isFavorite,isArchived: isArchived ?? this.isArchived,);Bookmark copyWithCompanion(BookmarksCompanion data) {
return Bookmark(
id: data.id.present ? data.id.value : this.id,url: data.url.present ? data.url.value : this.url,title: data.title.present ? data.title.value : this.title,description: data.description.present ? data.description.value : this.description,thumbnailUrl: data.thumbnailUrl.present ? data.thumbnailUrl.value : this.thumbnailUrl,faviconUrl: data.faviconUrl.present ? data.faviconUrl.value : this.faviconUrl,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,notes: data.notes.present ? data.notes.value : this.notes,category: data.category.present ? data.category.value : this.category,folderId: data.folderId.present ? data.folderId.value : this.folderId,isFavorite: data.isFavorite.present ? data.isFavorite.value : this.isFavorite,isArchived: data.isArchived.present ? data.isArchived.value : this.isArchived,);
}
@override
String toString() {return (StringBuffer('Bookmark(')..write('id: $id, ')..write('url: $url, ')..write('title: $title, ')..write('description: $description, ')..write('thumbnailUrl: $thumbnailUrl, ')..write('faviconUrl: $faviconUrl, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('notes: $notes, ')..write('category: $category, ')..write('folderId: $folderId, ')..write('isFavorite: $isFavorite, ')..write('isArchived: $isArchived')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, url, title, description, thumbnailUrl, faviconUrl, createdAt, updatedAt, notes, category, folderId, isFavorite, isArchived);@override
bool operator ==(Object other) => identical(this, other) || (other is Bookmark && other.id == this.id && other.url == this.url && other.title == this.title && other.description == this.description && other.thumbnailUrl == this.thumbnailUrl && other.faviconUrl == this.faviconUrl && other.createdAt == this.createdAt && other.updatedAt == this.updatedAt && other.notes == this.notes && other.category == this.category && other.folderId == this.folderId && other.isFavorite == this.isFavorite && other.isArchived == this.isArchived);
}class BookmarksCompanion extends UpdateCompanion<Bookmark> {
final Value<int> id;
final Value<String> url;
final Value<String> title;
final Value<String?> description;
final Value<String?> thumbnailUrl;
final Value<String?> faviconUrl;
final Value<DateTime> createdAt;
final Value<DateTime> updatedAt;
final Value<String?> notes;
final Value<String?> category;
final Value<int?> folderId;
final Value<bool> isFavorite;
final Value<bool> isArchived;
const BookmarksCompanion({this.id = const Value.absent(),this.url = const Value.absent(),this.title = const Value.absent(),this.description = const Value.absent(),this.thumbnailUrl = const Value.absent(),this.faviconUrl = const Value.absent(),this.createdAt = const Value.absent(),this.updatedAt = const Value.absent(),this.notes = const Value.absent(),this.category = const Value.absent(),this.folderId = const Value.absent(),this.isFavorite = const Value.absent(),this.isArchived = const Value.absent(),});
BookmarksCompanion.insert({this.id = const Value.absent(),required String url,required String title,this.description = const Value.absent(),this.thumbnailUrl = const Value.absent(),this.faviconUrl = const Value.absent(),required DateTime createdAt,required DateTime updatedAt,this.notes = const Value.absent(),this.category = const Value.absent(),this.folderId = const Value.absent(),this.isFavorite = const Value.absent(),this.isArchived = const Value.absent(),}): url = Value(url), title = Value(title), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
static Insertable<Bookmark> custom({Expression<int>? id, 
Expression<String>? url, 
Expression<String>? title, 
Expression<String>? description, 
Expression<String>? thumbnailUrl, 
Expression<String>? faviconUrl, 
Expression<DateTime>? createdAt, 
Expression<DateTime>? updatedAt, 
Expression<String>? notes, 
Expression<String>? category, 
Expression<int>? folderId, 
Expression<bool>? isFavorite, 
Expression<bool>? isArchived, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (url != null)'url': url,if (title != null)'title': title,if (description != null)'description': description,if (thumbnailUrl != null)'thumbnail_url': thumbnailUrl,if (faviconUrl != null)'favicon_url': faviconUrl,if (createdAt != null)'created_at': createdAt,if (updatedAt != null)'updated_at': updatedAt,if (notes != null)'notes': notes,if (category != null)'category': category,if (folderId != null)'folder_id': folderId,if (isFavorite != null)'is_favorite': isFavorite,if (isArchived != null)'is_archived': isArchived,});
}BookmarksCompanion copyWith({Value<int>? id, Value<String>? url, Value<String>? title, Value<String?>? description, Value<String?>? thumbnailUrl, Value<String?>? faviconUrl, Value<DateTime>? createdAt, Value<DateTime>? updatedAt, Value<String?>? notes, Value<String?>? category, Value<int?>? folderId, Value<bool>? isFavorite, Value<bool>? isArchived}) {
return BookmarksCompanion(id: id ?? this.id,url: url ?? this.url,title: title ?? this.title,description: description ?? this.description,thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,faviconUrl: faviconUrl ?? this.faviconUrl,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,notes: notes ?? this.notes,category: category ?? this.category,folderId: folderId ?? this.folderId,isFavorite: isFavorite ?? this.isFavorite,isArchived: isArchived ?? this.isArchived,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<int>(id.value);}
if (url.present) {
map['url'] = Variable<String>(url.value);}
if (title.present) {
map['title'] = Variable<String>(title.value);}
if (description.present) {
map['description'] = Variable<String>(description.value);}
if (thumbnailUrl.present) {
map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);}
if (faviconUrl.present) {
map['favicon_url'] = Variable<String>(faviconUrl.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (updatedAt.present) {
map['updated_at'] = Variable<DateTime>(updatedAt.value);}
if (notes.present) {
map['notes'] = Variable<String>(notes.value);}
if (category.present) {
map['category'] = Variable<String>(category.value);}
if (folderId.present) {
map['folder_id'] = Variable<int>(folderId.value);}
if (isFavorite.present) {
map['is_favorite'] = Variable<bool>(isFavorite.value);}
if (isArchived.present) {
map['is_archived'] = Variable<bool>(isArchived.value);}
return map; 
}
@override
String toString() {return (StringBuffer('BookmarksCompanion(')..write('id: $id, ')..write('url: $url, ')..write('title: $title, ')..write('description: $description, ')..write('thumbnailUrl: $thumbnailUrl, ')..write('faviconUrl: $faviconUrl, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('notes: $notes, ')..write('category: $category, ')..write('folderId: $folderId, ')..write('isFavorite: $isFavorite, ')..write('isArchived: $isArchived')..write(')')).toString();}
}
class $TagsTable extends Tags with TableInfo<$TagsTable, Tag>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$TagsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _nameMeta = const VerificationMeta('name');
@override
late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1,), type: DriftSqlType.string, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
static const VerificationMeta _colorMeta = const VerificationMeta('color');
@override
late final GeneratedColumn<String> color = GeneratedColumn<String>('color', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
@override
List<GeneratedColumn> get $columns => [id, name, color];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'tags';
@override
VerificationContext validateIntegrity(Insertable<Tag> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));}if (data.containsKey('name')) {
context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));} else if (isInserting) {
context.missing(_nameMeta);
}
if (data.containsKey('color')) {
context.handle(_colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));}return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {id};
@override Tag map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return Tag(id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!, name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!, color: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}color']), );
}
@override
$TagsTable createAlias(String alias) {
return $TagsTable(attachedDatabase, alias);}}class Tag extends DataClass implements Insertable<Tag> 
{
final int id;
final String name;
final String? color;
const Tag({required this.id, required this.name, this.color});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<int>(id);
map['name'] = Variable<String>(name);
if (!nullToAbsent || color != null){map['color'] = Variable<String>(color);
}return map; 
}
TagsCompanion toCompanion(bool nullToAbsent) {
return TagsCompanion(id: Value(id),name: Value(name),color: color == null && nullToAbsent ? const Value.absent() : Value(color),);
}
factory Tag.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return Tag(id: serializer.fromJson<int>(json['id']),name: serializer.fromJson<String>(json['name']),color: serializer.fromJson<String?>(json['color']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<int>(id),'name': serializer.toJson<String>(name),'color': serializer.toJson<String?>(color),};}Tag copyWith({int? id,String? name,Value<String?> color = const Value.absent()}) => Tag(id: id ?? this.id,name: name ?? this.name,color: color.present ? color.value : this.color,);Tag copyWithCompanion(TagsCompanion data) {
return Tag(
id: data.id.present ? data.id.value : this.id,name: data.name.present ? data.name.value : this.name,color: data.color.present ? data.color.value : this.color,);
}
@override
String toString() {return (StringBuffer('Tag(')..write('id: $id, ')..write('name: $name, ')..write('color: $color')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, name, color);@override
bool operator ==(Object other) => identical(this, other) || (other is Tag && other.id == this.id && other.name == this.name && other.color == this.color);
}class TagsCompanion extends UpdateCompanion<Tag> {
final Value<int> id;
final Value<String> name;
final Value<String?> color;
const TagsCompanion({this.id = const Value.absent(),this.name = const Value.absent(),this.color = const Value.absent(),});
TagsCompanion.insert({this.id = const Value.absent(),required String name,this.color = const Value.absent(),}): name = Value(name);
static Insertable<Tag> custom({Expression<int>? id, 
Expression<String>? name, 
Expression<String>? color, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (name != null)'name': name,if (color != null)'color': color,});
}TagsCompanion copyWith({Value<int>? id, Value<String>? name, Value<String?>? color}) {
return TagsCompanion(id: id ?? this.id,name: name ?? this.name,color: color ?? this.color,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<int>(id.value);}
if (name.present) {
map['name'] = Variable<String>(name.value);}
if (color.present) {
map['color'] = Variable<String>(color.value);}
return map; 
}
@override
String toString() {return (StringBuffer('TagsCompanion(')..write('id: $id, ')..write('name: $name, ')..write('color: $color')..write(')')).toString();}
}
class $BookmarkTagsTable extends BookmarkTags with TableInfo<$BookmarkTagsTable, BookmarkTag>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$BookmarkTagsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _bookmarkIdMeta = const VerificationMeta('bookmarkId');
@override
late final GeneratedColumn<int> bookmarkId = GeneratedColumn<int>('bookmark_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES bookmarks (id) ON DELETE CASCADE'));
static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
@override
late final GeneratedColumn<int> tagId = GeneratedColumn<int>('tag_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES tags (id) ON DELETE CASCADE'));
@override
List<GeneratedColumn> get $columns => [bookmarkId, tagId];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'bookmark_tags';
@override
VerificationContext validateIntegrity(Insertable<BookmarkTag> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('bookmark_id')) {
context.handle(_bookmarkIdMeta, bookmarkId.isAcceptableOrUnknown(data['bookmark_id']!, _bookmarkIdMeta));} else if (isInserting) {
context.missing(_bookmarkIdMeta);
}
if (data.containsKey('tag_id')) {
context.handle(_tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));} else if (isInserting) {
context.missing(_tagIdMeta);
}
return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {bookmarkId, tagId};
@override BookmarkTag map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return BookmarkTag(bookmarkId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}bookmark_id'])!, tagId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}tag_id'])!, );
}
@override
$BookmarkTagsTable createAlias(String alias) {
return $BookmarkTagsTable(attachedDatabase, alias);}}class BookmarkTag extends DataClass implements Insertable<BookmarkTag> 
{
final int bookmarkId;
final int tagId;
const BookmarkTag({required this.bookmarkId, required this.tagId});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['bookmark_id'] = Variable<int>(bookmarkId);
map['tag_id'] = Variable<int>(tagId);
return map; 
}
BookmarkTagsCompanion toCompanion(bool nullToAbsent) {
return BookmarkTagsCompanion(bookmarkId: Value(bookmarkId),tagId: Value(tagId),);
}
factory BookmarkTag.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return BookmarkTag(bookmarkId: serializer.fromJson<int>(json['bookmarkId']),tagId: serializer.fromJson<int>(json['tagId']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'bookmarkId': serializer.toJson<int>(bookmarkId),'tagId': serializer.toJson<int>(tagId),};}BookmarkTag copyWith({int? bookmarkId,int? tagId}) => BookmarkTag(bookmarkId: bookmarkId ?? this.bookmarkId,tagId: tagId ?? this.tagId,);BookmarkTag copyWithCompanion(BookmarkTagsCompanion data) {
return BookmarkTag(
bookmarkId: data.bookmarkId.present ? data.bookmarkId.value : this.bookmarkId,tagId: data.tagId.present ? data.tagId.value : this.tagId,);
}
@override
String toString() {return (StringBuffer('BookmarkTag(')..write('bookmarkId: $bookmarkId, ')..write('tagId: $tagId')..write(')')).toString();}
@override
 int get hashCode => Object.hash(bookmarkId, tagId);@override
bool operator ==(Object other) => identical(this, other) || (other is BookmarkTag && other.bookmarkId == this.bookmarkId && other.tagId == this.tagId);
}class BookmarkTagsCompanion extends UpdateCompanion<BookmarkTag> {
final Value<int> bookmarkId;
final Value<int> tagId;
final Value<int> rowid;
const BookmarkTagsCompanion({this.bookmarkId = const Value.absent(),this.tagId = const Value.absent(),this.rowid = const Value.absent(),});
BookmarkTagsCompanion.insert({required int bookmarkId,required int tagId,this.rowid = const Value.absent(),}): bookmarkId = Value(bookmarkId), tagId = Value(tagId);
static Insertable<BookmarkTag> custom({Expression<int>? bookmarkId, 
Expression<int>? tagId, 
Expression<int>? rowid, 
}) {
return RawValuesInsertable({if (bookmarkId != null)'bookmark_id': bookmarkId,if (tagId != null)'tag_id': tagId,if (rowid != null)'rowid': rowid,});
}BookmarkTagsCompanion copyWith({Value<int>? bookmarkId, Value<int>? tagId, Value<int>? rowid}) {
return BookmarkTagsCompanion(bookmarkId: bookmarkId ?? this.bookmarkId,tagId: tagId ?? this.tagId,rowid: rowid ?? this.rowid,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (bookmarkId.present) {
map['bookmark_id'] = Variable<int>(bookmarkId.value);}
if (tagId.present) {
map['tag_id'] = Variable<int>(tagId.value);}
if (rowid.present) {
map['rowid'] = Variable<int>(rowid.value);}
return map; 
}
@override
String toString() {return (StringBuffer('BookmarkTagsCompanion(')..write('bookmarkId: $bookmarkId, ')..write('tagId: $tagId, ')..write('rowid: $rowid')..write(')')).toString();}
}
class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$FoldersTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _nameMeta = const VerificationMeta('name');
@override
late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1,), type: DriftSqlType.string, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
static const VerificationMeta _parentIdMeta = const VerificationMeta('parentId');
@override
late final GeneratedColumn<int> parentId = GeneratedColumn<int>('parent_id', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES folders (id)'));
static const VerificationMeta _iconMeta = const VerificationMeta('icon');
@override
late final GeneratedColumn<String> icon = GeneratedColumn<String>('icon', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
@override
List<GeneratedColumn> get $columns => [id, name, parentId, icon];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'folders';
@override
VerificationContext validateIntegrity(Insertable<Folder> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));}if (data.containsKey('name')) {
context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));} else if (isInserting) {
context.missing(_nameMeta);
}
if (data.containsKey('parent_id')) {
context.handle(_parentIdMeta, parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));}if (data.containsKey('icon')) {
context.handle(_iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));}return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {id};
@override Folder map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return Folder(id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!, name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!, parentId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}parent_id']), icon: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}icon']), );
}
@override
$FoldersTable createAlias(String alias) {
return $FoldersTable(attachedDatabase, alias);}}class Folder extends DataClass implements Insertable<Folder> 
{
final int id;
final String name;
final int? parentId;
final String? icon;
const Folder({required this.id, required this.name, this.parentId, this.icon});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<int>(id);
map['name'] = Variable<String>(name);
if (!nullToAbsent || parentId != null){map['parent_id'] = Variable<int>(parentId);
}if (!nullToAbsent || icon != null){map['icon'] = Variable<String>(icon);
}return map; 
}
FoldersCompanion toCompanion(bool nullToAbsent) {
return FoldersCompanion(id: Value(id),name: Value(name),parentId: parentId == null && nullToAbsent ? const Value.absent() : Value(parentId),icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),);
}
factory Folder.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return Folder(id: serializer.fromJson<int>(json['id']),name: serializer.fromJson<String>(json['name']),parentId: serializer.fromJson<int?>(json['parentId']),icon: serializer.fromJson<String?>(json['icon']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<int>(id),'name': serializer.toJson<String>(name),'parentId': serializer.toJson<int?>(parentId),'icon': serializer.toJson<String?>(icon),};}Folder copyWith({int? id,String? name,Value<int?> parentId = const Value.absent(),Value<String?> icon = const Value.absent()}) => Folder(id: id ?? this.id,name: name ?? this.name,parentId: parentId.present ? parentId.value : this.parentId,icon: icon.present ? icon.value : this.icon,);Folder copyWithCompanion(FoldersCompanion data) {
return Folder(
id: data.id.present ? data.id.value : this.id,name: data.name.present ? data.name.value : this.name,parentId: data.parentId.present ? data.parentId.value : this.parentId,icon: data.icon.present ? data.icon.value : this.icon,);
}
@override
String toString() {return (StringBuffer('Folder(')..write('id: $id, ')..write('name: $name, ')..write('parentId: $parentId, ')..write('icon: $icon')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, name, parentId, icon);@override
bool operator ==(Object other) => identical(this, other) || (other is Folder && other.id == this.id && other.name == this.name && other.parentId == this.parentId && other.icon == this.icon);
}class FoldersCompanion extends UpdateCompanion<Folder> {
final Value<int> id;
final Value<String> name;
final Value<int?> parentId;
final Value<String?> icon;
const FoldersCompanion({this.id = const Value.absent(),this.name = const Value.absent(),this.parentId = const Value.absent(),this.icon = const Value.absent(),});
FoldersCompanion.insert({this.id = const Value.absent(),required String name,this.parentId = const Value.absent(),this.icon = const Value.absent(),}): name = Value(name);
static Insertable<Folder> custom({Expression<int>? id, 
Expression<String>? name, 
Expression<int>? parentId, 
Expression<String>? icon, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (name != null)'name': name,if (parentId != null)'parent_id': parentId,if (icon != null)'icon': icon,});
}FoldersCompanion copyWith({Value<int>? id, Value<String>? name, Value<int?>? parentId, Value<String?>? icon}) {
return FoldersCompanion(id: id ?? this.id,name: name ?? this.name,parentId: parentId ?? this.parentId,icon: icon ?? this.icon,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<int>(id.value);}
if (name.present) {
map['name'] = Variable<String>(name.value);}
if (parentId.present) {
map['parent_id'] = Variable<int>(parentId.value);}
if (icon.present) {
map['icon'] = Variable<String>(icon.value);}
return map; 
}
@override
String toString() {return (StringBuffer('FoldersCompanion(')..write('id: $id, ')..write('name: $name, ')..write('parentId: $parentId, ')..write('icon: $icon')..write(')')).toString();}
}
abstract class _$AppDatabase extends GeneratedDatabase{
_$AppDatabase(QueryExecutor e): super(e);
$AppDatabaseManager get managers => $AppDatabaseManager(this);
late final $BookmarksTable bookmarks = $BookmarksTable(this);
late final $TagsTable tags = $TagsTable(this);
late final $BookmarkTagsTable bookmarkTags = $BookmarkTagsTable(this);
late final $FoldersTable folders = $FoldersTable(this);
@override
Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
@override
List<DatabaseSchemaEntity> get allSchemaEntities => [bookmarks, tags, bookmarkTags, folders];
@override
StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([WritePropagation(on: TableUpdateQuery.onTableName('bookmarks' , limitUpdateKind: UpdateKind.delete), result: [TableUpdate('bookmark_tags', kind: UpdateKind.delete), ],), WritePropagation(on: TableUpdateQuery.onTableName('tags' , limitUpdateKind: UpdateKind.delete), result: [TableUpdate('bookmark_tags', kind: UpdateKind.delete), ],), ],);
}
typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({Value<int> id,required String url,required String title,Value<String?> description,Value<String?> thumbnailUrl,Value<String?> faviconUrl,required DateTime createdAt,required DateTime updatedAt,Value<String?> notes,Value<String?> category,Value<int?> folderId,Value<bool> isFavorite,Value<bool> isArchived,});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({Value<int> id,Value<String> url,Value<String> title,Value<String?> description,Value<String?> thumbnailUrl,Value<String?> faviconUrl,Value<DateTime> createdAt,Value<DateTime> updatedAt,Value<String?> notes,Value<String?> category,Value<int?> folderId,Value<bool> isFavorite,Value<bool> isArchived,});
      final class $$BookmarksTableReferences extends BaseReferences<
        _$AppDatabase,
        $BookmarksTable,
        Bookmark> {
        $$BookmarksTableReferences(super.$_db, super.$_table, super.$_typedResult);
        
                  
                  static MultiTypedResultKey<
          $BookmarkTagsTable,
          List<BookmarkTag>
        > _bookmarkTagsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(
          db.bookmarkTags, 
          aliasName: $_aliasNameGenerator(
            db.bookmarks.id,
            db.bookmarkTags.bookmarkId)
        );

          $$BookmarkTagsTableProcessedTableManager get bookmarkTagsRefs {
        final manager = $$BookmarkTagsTableTableManager(
            $_db, $_db.bookmarkTags
            ).filter(
              (f) => f.bookmarkId.id(
              $_item.id
            )
          );

          final cache = $_typedResult.readTableOrNull(_bookmarkTagsRefsTable($_db));
          return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));


        }
        

      }class $$BookmarksTableFilterComposer extends Composer<
        _$AppDatabase,
        $BookmarksTable> {
        $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get url => $composableBuilder(
      column: $table.url,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get title => $composableBuilder(
      column: $table.title,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get description => $composableBuilder(
      column: $table.description,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get faviconUrl => $composableBuilder(
      column: $table.faviconUrl,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get category => $composableBuilder(
      column: $table.category,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get folderId => $composableBuilder(
      column: $table.folderId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived,
      builder: (column) => 
      ColumnFilters(column));
      
        Expression<bool> bookmarkTagsRefs(
          Expression<bool> Function( $$BookmarkTagsTableFilterComposer f) f
        ) {
                final $$BookmarkTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarkTags,
      getReferencedColumn: (t) => t.bookmarkId,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$BookmarkTagsTableFilterComposer(
              $db: $db,
              $table: $db.bookmarkTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return f(composer);
        }

        }
      class $$BookmarksTableOrderingComposer extends Composer<
        _$AppDatabase,
        $BookmarksTable> {
        $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get faviconUrl => $composableBuilder(
      column: $table.faviconUrl,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get folderId => $composableBuilder(
      column: $table.folderId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$BookmarksTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $BookmarksTable> {
        $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get url => $composableBuilder(
      column: $table.url,
      builder: (column) => column);
      
GeneratedColumn<String> get title => $composableBuilder(
      column: $table.title,
      builder: (column) => column);
      
GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description,
      builder: (column) => column);
      
GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl,
      builder: (column) => column);
      
GeneratedColumn<String> get faviconUrl => $composableBuilder(
      column: $table.faviconUrl,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => column);
      
GeneratedColumn<String> get notes => $composableBuilder(
      column: $table.notes,
      builder: (column) => column);
      
GeneratedColumn<String> get category => $composableBuilder(
      column: $table.category,
      builder: (column) => column);
      
GeneratedColumn<int> get folderId => $composableBuilder(
      column: $table.folderId,
      builder: (column) => column);
      
GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite,
      builder: (column) => column);
      
GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived,
      builder: (column) => column);
      
        Expression<T> bookmarkTagsRefs<T extends Object>(
          Expression<T> Function( $$BookmarkTagsTableAnnotationComposer a) f
        ) {
                final $$BookmarkTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarkTags,
      getReferencedColumn: (t) => t.bookmarkId,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$BookmarkTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.bookmarkTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return f(composer);
        }

        }
      class $$BookmarksTableTableManager extends RootTableManager    <_$AppDatabase,
    $BookmarksTable,
    Bookmark,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (Bookmark,$$BookmarksTableReferences),
    Bookmark,
    PrefetchHooks Function({bool bookmarkTagsRefs})
    > {
    $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$BookmarksTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$BookmarksTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$BookmarksTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> id = const Value.absent(),Value<String> url = const Value.absent(),Value<String> title = const Value.absent(),Value<String?> description = const Value.absent(),Value<String?> thumbnailUrl = const Value.absent(),Value<String?> faviconUrl = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<DateTime> updatedAt = const Value.absent(),Value<String?> notes = const Value.absent(),Value<String?> category = const Value.absent(),Value<int?> folderId = const Value.absent(),Value<bool> isFavorite = const Value.absent(),Value<bool> isArchived = const Value.absent(),})=> BookmarksCompanion(id: id,url: url,title: title,description: description,thumbnailUrl: thumbnailUrl,faviconUrl: faviconUrl,createdAt: createdAt,updatedAt: updatedAt,notes: notes,category: category,folderId: folderId,isFavorite: isFavorite,isArchived: isArchived,),
        createCompanionCallback: ({Value<int> id = const Value.absent(),required String url,required String title,Value<String?> description = const Value.absent(),Value<String?> thumbnailUrl = const Value.absent(),Value<String?> faviconUrl = const Value.absent(),required DateTime createdAt,required DateTime updatedAt,Value<String?> notes = const Value.absent(),Value<String?> category = const Value.absent(),Value<int?> folderId = const Value.absent(),Value<bool> isFavorite = const Value.absent(),Value<bool> isArchived = const Value.absent(),})=> BookmarksCompanion.insert(id: id,url: url,title: title,description: description,thumbnailUrl: thumbnailUrl,faviconUrl: faviconUrl,createdAt: createdAt,updatedAt: updatedAt,notes: notes,category: category,folderId: folderId,isFavorite: isFavorite,isArchived: isArchived,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), $$BookmarksTableReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback:         ({bookmarkTagsRefs = false}){
          return PrefetchHooks(
            db: db,
            explicitlyWatchedTables: [
             if (bookmarkTagsRefs) db.bookmarkTags
            ],
            addJoins: null,
            getPrefetchedDataCallback: (items) async {
            return [
                      if (bookmarkTagsRefs) await $_getPrefetchedData(
                  currentTable: table,
                  referencedTable:
                      $$BookmarksTableReferences._bookmarkTagsRefsTable(db),
                  managerFromTypedResult: (p0) =>
                      $$BookmarksTableReferences(db, table, p0).bookmarkTagsRefs,
                  referencedItemsForCurrentItem: (item, referencedItems) =>
                      referencedItems.where((e) => e.bookmarkId == item.id),
                  typedResults: items)
            
                ];
              },
          );
        }
,
        ));
        }
    typedef $$BookmarksTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $BookmarksTable,
    Bookmark,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (Bookmark,$$BookmarksTableReferences),
    Bookmark,
    PrefetchHooks Function({bool bookmarkTagsRefs})
    >;typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({Value<int> id,required String name,Value<String?> color,});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({Value<int> id,Value<String> name,Value<String?> color,});
      final class $$TagsTableReferences extends BaseReferences<
        _$AppDatabase,
        $TagsTable,
        Tag> {
        $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);
        
                  
                  static MultiTypedResultKey<
          $BookmarkTagsTable,
          List<BookmarkTag>
        > _bookmarkTagsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(
          db.bookmarkTags, 
          aliasName: $_aliasNameGenerator(
            db.tags.id,
            db.bookmarkTags.tagId)
        );

          $$BookmarkTagsTableProcessedTableManager get bookmarkTagsRefs {
        final manager = $$BookmarkTagsTableTableManager(
            $_db, $_db.bookmarkTags
            ).filter(
              (f) => f.tagId.id(
              $_item.id
            )
          );

          final cache = $_typedResult.readTableOrNull(_bookmarkTagsRefsTable($_db));
          return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));


        }
        

      }class $$TagsTableFilterComposer extends Composer<
        _$AppDatabase,
        $TagsTable> {
        $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get color => $composableBuilder(
      column: $table.color,
      builder: (column) => 
      ColumnFilters(column));
      
        Expression<bool> bookmarkTagsRefs(
          Expression<bool> Function( $$BookmarkTagsTableFilterComposer f) f
        ) {
                final $$BookmarkTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarkTags,
      getReferencedColumn: (t) => t.tagId,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$BookmarkTagsTableFilterComposer(
              $db: $db,
              $table: $db.bookmarkTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return f(composer);
        }

        }
      class $$TagsTableOrderingComposer extends Composer<
        _$AppDatabase,
        $TagsTable> {
        $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$TagsTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $TagsTable> {
        $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => column);
      
GeneratedColumn<String> get color => $composableBuilder(
      column: $table.color,
      builder: (column) => column);
      
        Expression<T> bookmarkTagsRefs<T extends Object>(
          Expression<T> Function( $$BookmarkTagsTableAnnotationComposer a) f
        ) {
                final $$BookmarkTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarkTags,
      getReferencedColumn: (t) => t.tagId,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$BookmarkTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.bookmarkTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return f(composer);
        }

        }
      class $$TagsTableTableManager extends RootTableManager    <_$AppDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag,$$TagsTableReferences),
    Tag,
    PrefetchHooks Function({bool bookmarkTagsRefs})
    > {
    $$TagsTableTableManager(_$AppDatabase db, $TagsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$TagsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$TagsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$TagsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> id = const Value.absent(),Value<String> name = const Value.absent(),Value<String?> color = const Value.absent(),})=> TagsCompanion(id: id,name: name,color: color,),
        createCompanionCallback: ({Value<int> id = const Value.absent(),required String name,Value<String?> color = const Value.absent(),})=> TagsCompanion.insert(id: id,name: name,color: color,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), $$TagsTableReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback:         ({bookmarkTagsRefs = false}){
          return PrefetchHooks(
            db: db,
            explicitlyWatchedTables: [
             if (bookmarkTagsRefs) db.bookmarkTags
            ],
            addJoins: null,
            getPrefetchedDataCallback: (items) async {
            return [
                      if (bookmarkTagsRefs) await $_getPrefetchedData(
                  currentTable: table,
                  referencedTable:
                      $$TagsTableReferences._bookmarkTagsRefsTable(db),
                  managerFromTypedResult: (p0) =>
                      $$TagsTableReferences(db, table, p0).bookmarkTagsRefs,
                  referencedItemsForCurrentItem: (item, referencedItems) =>
                      referencedItems.where((e) => e.tagId == item.id),
                  typedResults: items)
            
                ];
              },
          );
        }
,
        ));
        }
    typedef $$TagsTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag,$$TagsTableReferences),
    Tag,
    PrefetchHooks Function({bool bookmarkTagsRefs})
    >;typedef $$BookmarkTagsTableCreateCompanionBuilder = BookmarkTagsCompanion Function({required int bookmarkId,required int tagId,Value<int> rowid,});
typedef $$BookmarkTagsTableUpdateCompanionBuilder = BookmarkTagsCompanion Function({Value<int> bookmarkId,Value<int> tagId,Value<int> rowid,});
      final class $$BookmarkTagsTableReferences extends BaseReferences<
        _$AppDatabase,
        $BookmarkTagsTable,
        BookmarkTag> {
        $$BookmarkTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);
        
                          static $BookmarksTable _bookmarkIdTable(_$AppDatabase db) => 
            db.bookmarks.createAlias($_aliasNameGenerator(
            db.bookmarkTags.bookmarkId,
            db.bookmarks.id));
          

        $$BookmarksTableProcessedTableManager? get bookmarkId {
          if ($_item.bookmarkId == null) return null;
          final manager = $$BookmarksTableTableManager($_db, $_db.bookmarks).filter((f) => f.id($_item.bookmarkId!));
          final item = $_typedResult.readTableOrNull(_bookmarkIdTable($_db));
          if (item == null) return manager;
          return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
        }

                  static $TagsTable _tagIdTable(_$AppDatabase db) => 
            db.tags.createAlias($_aliasNameGenerator(
            db.bookmarkTags.tagId,
            db.tags.id));
          

        $$TagsTableProcessedTableManager? get tagId {
          if ($_item.tagId == null) return null;
          final manager = $$TagsTableTableManager($_db, $_db.tags).filter((f) => f.id($_item.tagId!));
          final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
          if (item == null) return manager;
          return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
        }


      }class $$BookmarkTagsTableFilterComposer extends Composer<
        _$AppDatabase,
        $BookmarkTagsTable> {
        $$BookmarkTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
                  $$BookmarksTableFilterComposer get bookmarkId {
                final $$BookmarksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookmarkId,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$BookmarksTableFilterComposer(
              $db: $db,
              $table: $db.bookmarks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return composer;
        }
        $$TagsTableFilterComposer get tagId {
                final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$TagsTableFilterComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return composer;
        }
        }
      class $$BookmarkTagsTableOrderingComposer extends Composer<
        _$AppDatabase,
        $BookmarkTagsTable> {
        $$BookmarkTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
                  $$BookmarksTableOrderingComposer get bookmarkId {
                final $$BookmarksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookmarkId,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$BookmarksTableOrderingComposer(
              $db: $db,
              $table: $db.bookmarks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return composer;
        }
        $$TagsTableOrderingComposer get tagId {
                final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$TagsTableOrderingComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return composer;
        }
        }
      class $$BookmarkTagsTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $BookmarkTagsTable> {
        $$BookmarkTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
                  $$BookmarksTableAnnotationComposer get bookmarkId {
                final $$BookmarksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookmarkId,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$BookmarksTableAnnotationComposer(
              $db: $db,
              $table: $db.bookmarks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return composer;
        }
        $$TagsTableAnnotationComposer get tagId {
                final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$TagsTableAnnotationComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return composer;
        }
        }
      class $$BookmarkTagsTableTableManager extends RootTableManager    <_$AppDatabase,
    $BookmarkTagsTable,
    BookmarkTag,
    $$BookmarkTagsTableFilterComposer,
    $$BookmarkTagsTableOrderingComposer,
    $$BookmarkTagsTableAnnotationComposer,
    $$BookmarkTagsTableCreateCompanionBuilder,
    $$BookmarkTagsTableUpdateCompanionBuilder,
    (BookmarkTag,$$BookmarkTagsTableReferences),
    BookmarkTag,
    PrefetchHooks Function({bool bookmarkId,bool tagId})
    > {
    $$BookmarkTagsTableTableManager(_$AppDatabase db, $BookmarkTagsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$BookmarkTagsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$BookmarkTagsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$BookmarkTagsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> bookmarkId = const Value.absent(),Value<int> tagId = const Value.absent(),Value<int> rowid = const Value.absent(),})=> BookmarkTagsCompanion(bookmarkId: bookmarkId,tagId: tagId,rowid: rowid,),
        createCompanionCallback: ({required int bookmarkId,required int tagId,Value<int> rowid = const Value.absent(),})=> BookmarkTagsCompanion.insert(bookmarkId: bookmarkId,tagId: tagId,rowid: rowid,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), $$BookmarkTagsTableReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback:         ({bookmarkId = false,tagId = false}){
          return PrefetchHooks(
            db: db,
            explicitlyWatchedTables: [
             
            ],
            addJoins: <T extends TableManagerState<dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic>>(state) {

                                  if (bookmarkId){
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.bookmarkId,
                    referencedTable:
                        $$BookmarkTagsTableReferences._bookmarkIdTable(db),
                    referencedColumn:
                        $$BookmarkTagsTableReferences._bookmarkIdTable(db).id,
                  ) as T;
               }
                  if (tagId){
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tagId,
                    referencedTable:
                        $$BookmarkTagsTableReferences._tagIdTable(db),
                    referencedColumn:
                        $$BookmarkTagsTableReferences._tagIdTable(db).id,
                  ) as T;
               }

                return state;
              }
,
            getPrefetchedDataCallback: (items) async {
            return [
            
                ];
              },
          );
        }
,
        ));
        }
    typedef $$BookmarkTagsTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $BookmarkTagsTable,
    BookmarkTag,
    $$BookmarkTagsTableFilterComposer,
    $$BookmarkTagsTableOrderingComposer,
    $$BookmarkTagsTableAnnotationComposer,
    $$BookmarkTagsTableCreateCompanionBuilder,
    $$BookmarkTagsTableUpdateCompanionBuilder,
    (BookmarkTag,$$BookmarkTagsTableReferences),
    BookmarkTag,
    PrefetchHooks Function({bool bookmarkId,bool tagId})
    >;typedef $$FoldersTableCreateCompanionBuilder = FoldersCompanion Function({Value<int> id,required String name,Value<int?> parentId,Value<String?> icon,});
typedef $$FoldersTableUpdateCompanionBuilder = FoldersCompanion Function({Value<int> id,Value<String> name,Value<int?> parentId,Value<String?> icon,});
      final class $$FoldersTableReferences extends BaseReferences<
        _$AppDatabase,
        $FoldersTable,
        Folder> {
        $$FoldersTableReferences(super.$_db, super.$_table, super.$_typedResult);
        
                          static $FoldersTable _parentIdTable(_$AppDatabase db) => 
            db.folders.createAlias($_aliasNameGenerator(
            db.folders.parentId,
            db.folders.id));
          

        $$FoldersTableProcessedTableManager? get parentId {
          if ($_item.parentId == null) return null;
          final manager = $$FoldersTableTableManager($_db, $_db.folders).filter((f) => f.id($_item.parentId!));
          final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
          if (item == null) return manager;
          return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
        }


      }class $$FoldersTableFilterComposer extends Composer<
        _$AppDatabase,
        $FoldersTable> {
        $$FoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon,
      builder: (column) => 
      ColumnFilters(column));
      
        $$FoldersTableFilterComposer get parentId {
                final $$FoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$FoldersTableFilterComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return composer;
        }
        }
      class $$FoldersTableOrderingComposer extends Composer<
        _$AppDatabase,
        $FoldersTable> {
        $$FoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon,
      builder: (column) => 
      ColumnOrderings(column));
      
        $$FoldersTableOrderingComposer get parentId {
                final $$FoldersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$FoldersTableOrderingComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return composer;
        }
        }
      class $$FoldersTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $FoldersTable> {
        $$FoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => column);
      
GeneratedColumn<String> get icon => $composableBuilder(
      column: $table.icon,
      builder: (column) => column);
      
        $$FoldersTableAnnotationComposer get parentId {
                final $$FoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$FoldersTableAnnotationComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return composer;
        }
        }
      class $$FoldersTableTableManager extends RootTableManager    <_$AppDatabase,
    $FoldersTable,
    Folder,
    $$FoldersTableFilterComposer,
    $$FoldersTableOrderingComposer,
    $$FoldersTableAnnotationComposer,
    $$FoldersTableCreateCompanionBuilder,
    $$FoldersTableUpdateCompanionBuilder,
    (Folder,$$FoldersTableReferences),
    Folder,
    PrefetchHooks Function({bool parentId})
    > {
    $$FoldersTableTableManager(_$AppDatabase db, $FoldersTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$FoldersTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$FoldersTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$FoldersTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> id = const Value.absent(),Value<String> name = const Value.absent(),Value<int?> parentId = const Value.absent(),Value<String?> icon = const Value.absent(),})=> FoldersCompanion(id: id,name: name,parentId: parentId,icon: icon,),
        createCompanionCallback: ({Value<int> id = const Value.absent(),required String name,Value<int?> parentId = const Value.absent(),Value<String?> icon = const Value.absent(),})=> FoldersCompanion.insert(id: id,name: name,parentId: parentId,icon: icon,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), $$FoldersTableReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback:         ({parentId = false}){
          return PrefetchHooks(
            db: db,
            explicitlyWatchedTables: [
             
            ],
            addJoins: <T extends TableManagerState<dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic>>(state) {

                                  if (parentId){
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable:
                        $$FoldersTableReferences._parentIdTable(db),
                    referencedColumn:
                        $$FoldersTableReferences._parentIdTable(db).id,
                  ) as T;
               }

                return state;
              }
,
            getPrefetchedDataCallback: (items) async {
            return [
            
                ];
              },
          );
        }
,
        ));
        }
    typedef $$FoldersTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $FoldersTable,
    Folder,
    $$FoldersTableFilterComposer,
    $$FoldersTableOrderingComposer,
    $$FoldersTableAnnotationComposer,
    $$FoldersTableCreateCompanionBuilder,
    $$FoldersTableUpdateCompanionBuilder,
    (Folder,$$FoldersTableReferences),
    Folder,
    PrefetchHooks Function({bool parentId})
    >;class $AppDatabaseManager {
final _$AppDatabase _db;
$AppDatabaseManager(this._db);
$$BookmarksTableTableManager get bookmarks => $$BookmarksTableTableManager(_db, _db.bookmarks);
$$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
$$BookmarkTagsTableTableManager get bookmarkTags => $$BookmarkTagsTableTableManager(_db, _db.bookmarkTags);
$$FoldersTableTableManager get folders => $$FoldersTableTableManager(_db, _db.folders);
}
