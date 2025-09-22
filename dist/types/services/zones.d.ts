import { DependencyType, TagType } from '../helpers/types.ts';
export declare function createZoneWith(deps: DependencyType): (args: {
    data?: any;
    tags?: TagType[];
}, callback?: (status: any) => void) => Promise<string | null>;
export declare function updateZoneWith(deps: DependencyType): (args: object, zoneId: string) => Promise<string | null>;
export declare function addToZoneWith(deps: DependencyType): (args: {
    path: string;
    data: object;
}, zoneId: string) => Promise<string | null>;
export declare function updateZonePatchMapWith(deps: DependencyType): (args: object, zoneId: string) => Promise<string | null>;
export declare function setZoneRolesWith(deps: DependencyType): (args: {
    granteeId: string;
    roles: string[];
    type: "wallet" | "process";
    sendInvite: boolean;
}[], zoneId: string) => Promise<string | null>;
export declare function joinZoneWith(deps: DependencyType): (args: {
    zoneToJoinId: string;
    storePath?: string;
}, zoneId: string) => Promise<string | null>;
export declare function updateZoneVersionWith(deps: DependencyType): (args: {
    zoneId: string;
}) => Promise<string | null>;
export declare function getZoneWith(deps: DependencyType): (zoneId: string) => Promise<any | null>;
