import { cloudDatabase } from '@kit.CloudFoundationKit';

class Currentareainfo extends cloudDatabase.DatabaseObject{
  public naturalbase_ClassName(): string {
    return "CurrentAreaInfo";
  }
  public area_id:number|undefined
  public current_area:string|undefined;
}

export { Currentareainfo };