import * as Common from './common/index.ts';
import * as Helpers from './helpers/index.ts';
import * as Services from './services/index.ts';
export * as Types from './helpers/types.ts';
export declare const CurrentZoneVersion: string;
declare function init(deps: Helpers.DependencyType): {
    createZone: (args: {
        data?: any;
        tags?: Helpers.TagType[];
    }, callback?: (status: any) => void) => Promise<string | null>;
    updateZone: (args: object, zoneId: string) => Promise<string | null>;
    addToZone: (args: {
        path: string;
        data: object;
    }, zoneId: string) => Promise<string | null>;
    getZone: (zoneId: string) => Promise<any | null>;
    setZoneRoles: (args: {
        granteeId: string;
        roles: string[];
        type: "wallet" | "process";
        sendInvite: boolean;
    }[], zoneId: string) => Promise<string | null>;
    joinZone: (args: {
        zoneToJoinId: string;
        storePath?: string;
    }, zoneId: string) => Promise<string | null>;
    updateZonePatchMap: (args: object, zoneId: string) => Promise<string | null>;
    updateZoneVersion: (args: {
        zoneId: string;
    }) => Promise<string | null>;
    createProfile: (args: Helpers.ProfileArgsType, callback?: (status: any) => void) => Promise<string | null>;
    updateProfile: (args: Helpers.ProfileArgsType, profileId: string, callback?: (status: any) => void) => Promise<string | null>;
    updateProfileVersion: (args: {
        profileId: string;
    }) => Promise<string | null>;
    getProfileById: (profileId: string) => Promise<Helpers.ProfileType | null>;
    getProfileByWalletAddress: (walletAddress: string) => Promise<(Helpers.ProfileType & any) | null>;
    createAtomicAsset: (args: Helpers.AssetCreateArgsType, callback?: (status: any) => void) => Promise<string>;
    getAtomicAsset: (id: string, args?: {
        useGateway?: boolean;
    }) => Promise<Helpers.AssetDetailType | null>;
    getAtomicAssets: typeof Services.getAtomicAssets;
    createComment: (args: Helpers.CommentCreateArgType) => Promise<string>;
    getComments: (args: {
        commentsId: string;
    }) => Promise<any>;
    updateCommentStatus: (args: {
        commentsId: string;
        commentId: string;
        status: "active" | "inactive";
    }) => Promise<string>;
    removeComment: (args: {
        commentsId: string;
        commentId: string;
        status: "active" | "inactive";
    }) => Promise<string>;
    createCollection: (args: {
        title: string;
        description: string;
        creator: string;
        thumbnail: any;
        banner: any;
        skipRegistry?: boolean;
        skipActivity?: boolean;
    }, callback?: (status: any) => void) => Promise<string>;
    updateCollectionAssets: (args: {
        collectionId: string;
        assetIds: string[];
        creator: string;
        updateType: "Add" | "Remove";
    }) => Promise<string>;
    getCollection: (collectionId: string) => Promise<Helpers.CollectionDetailType | null>;
    getCollections: (args: {
        creator?: string;
    }) => Promise<Helpers.CollectionType[] | null>;
    resolveTransaction: (data: any) => Promise<any>;
    getGQLData: typeof Common.getGQLData;
    getAggregatedGQLData: typeof Common.getAggregatedGQLData;
    createProcess: (args: Helpers.ProcessCreateType, statusCB?: (status: any) => void) => Promise<string>;
    readProcess: (args: Helpers.MessageSendType) => Promise<any>;
    readState: (args: Helpers.ProcessReadType) => Promise<any>;
    sendMessage: (args: Helpers.MessageSendType) => Promise<string>;
    mapFromProcessCase: typeof Helpers.mapFromProcessCase;
    mapToProcessCase: typeof Helpers.mapToProcessCase;
};
declare const _default: {
    init: typeof init;
};
export default _default;
