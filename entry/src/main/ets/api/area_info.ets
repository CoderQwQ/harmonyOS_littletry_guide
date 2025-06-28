import { cloudDatabase } from '@kit.CloudFoundationKit';

class areainfo extends cloudDatabase.DatabaseObject{
  public naturalbase_ClassName(): string {
    return "AreaInfo";
  }
  public diqu: string | undefined;
  public jingdian1: string | undefined;
  public jingdian2: string | undefined;
  public jingdian3: string | undefined;
  public jingdian4: string | undefined;
  public jingdian5: string | undefined;
  public jingdian6: string | undefined;
  public jingdian7: string | undefined;
  public jingdian8: string | undefined;
}

export { areainfo };