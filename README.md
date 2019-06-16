# oracle_scripts
## awr

* スナップショット取得   
`$ sh snapshot.sh`
* 最新のスナップショットからAWRレポートを生成    
`$ sh awrrpt.sh`  
* AWRレポートを引数にSQLレポートを生成    
`$ sh sqlrpt.sh <AWRレポートファイル名>`  

## expimp
* スキーマモードでexport    
`$ sh expdp_schema.sh`  
* スキーマモードでimport  
`$ sh impdp_schema.sh`  
※Shell内で対象スキーマをdropしてからimpdpしているので注意

## index
* 対象スキーマの全indexについて自動的にrebuildコマンドを生成し実行   
`$ sh rebuild_index.sh`

## profile
* デフォルトプロファイルのパスワード無期限設定   
`$ sqlplus system/<パスワード>@<TNS名> @modify_default_profile.sql`

## stats
* 統計Export(expdpでスキーマ単位でMETADATA_ONLYでexport)  
`$ sh expdp_schema_stats.sh`  
* 統計Import(impdpでINCLUDE=STATISTICSでimport)  
`$ sh impdp_schema_stats.sh`   
* 対象スキーマの全tableについて自動的にdbms_statsコマンドを生成し実行   
`$ sh gather_stats.sh`
* 対象スキーマのテーブル、インデックス、カラム統計を表示   
`$ sh select_all_stats.sh`

## user
* スキーマの作成  
`$ sqlplus system/<パスワード>@<TNS名> @create_user.sql`  
* スキーマの削除  
`$ sqlplus system/<パスワード>@<TNS名> @drop_user.sql`  

