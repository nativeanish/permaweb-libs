local json = require('json')

-- Collections { Id, Name, Description, Creator, DateCreated, Banner, Thumbnail }[]
if not Collections then Collections = {} end

-- CollectionsByUser: { Creator: { CollectionIds } }
if not CollectionsByUser then CollectionsByUser = {} end

InitialSync = InitialSync or 'INCOMPLETE'
if InitialSync == 'INCOMPLETE' then
	Send({
		device = 'patch@1.0',
		cache = json.encode({
			Collections = Collections,
			CollectionsByUser = CollectionsByUser
		})
	})
	InitialSync = 'COMPLETE'
end

-- Add collection to registry
Handlers.add('Add-Collection', Handlers.utils.hasMatchingTag('Action', 'Add-Collection'), function(msg)
	local data = {
		Id = msg.Tags.CollectionId,
		Name = msg.Tags.Name,
		Description = msg.Tags.Description,
		Creator = msg.Tags.Creator,
		DateCreated = msg.Tags.DateCreated,
		Banner = msg.Tags.Banner,
		Thumbnail = msg.Tags.Thumbnail
	}

	local requiredFields = {
		{ key = 'Id',      name = 'CollectionId' },
		{ key = 'Name',    name = 'Name' },
		{ key = 'Creator', name = 'Creator' }
	}

	for _, field in ipairs(requiredFields) do
		if not data[field.key] or data[field.key] == '' then
			ao.send({
				Target = msg.From,
				Action = 'Action-Response',
				Tags = {
					Status = 'Error',
					Message = 'Invalid or missing ' .. field.name
				}
			})
			return
		end
	end

	for _, collection in ipairs(Collections) do
		if collection.Id == data.Id then
			ao.send({
				Target = msg.From,
				Action = 'Action-Response',
				Tags = {
					Status = 'Error',
					Message = 'Collection with this ID already exists'
				}
			})
			return
		end
	end

	table.insert(Collections, {
		Id = data.Id,
		Name = data.Name,
		Description = data.Description,
		Creator = data.Creator,
		DateCreated = data.DateCreated,
		Banner = data.Banner,
		Thumbnail = data.Thumbnail
	})

	if not CollectionsByUser[data.Creator] then
		CollectionsByUser[data.Creator] = {}
	end
	table.insert(CollectionsByUser[data.Creator], data.Id)

	Send({
		device = 'patch@1.0',
		cache = json.encode({
			Collections = Collections,
			CollectionsByUser = CollectionsByUser
		})
	})

	ao.send({
		Target = msg.From,
		Action = 'Action-Response',
		Tags = {
			Status = 'Success',
			Message = 'Collection added successfully'
		}
	})
end)

-- Get collections by user
Handlers.add('Get-Collections', Handlers.utils.hasMatchingTag('Action', 'Get-Collections'), function(msg)
	ao.send({
		Target = msg.From,
		Action = 'Action-Response',
		Tags = {
			Status = 'Success',
			Message = 'Collections fetched successfully'
		},
		Data = json.encode({ Collections = Collections })
	})
end)

-- Get collections by user
Handlers.add('Get-Collections-By-User', Handlers.utils.hasMatchingTag('Action', 'Get-Collections-By-User'), function(msg)
	local creator = msg.Tags.Creator

	if not creator or creator == '' then
		ao.send({
			Target = msg.From,
			Action = 'Action-Response',
			Tags = {
				Status = 'Error',
				Message = 'Invalid or missing Creator'
			}
		})
		return
	end

	local collectionIds = CollectionsByUser[creator] or {}
	local userCollections = {}

	for _, collectionId in ipairs(collectionIds) do
		for _, collection in ipairs(Collections) do
			if collection.Id == collectionId then
				table.insert(userCollections, collection)
				break
			end
		end
	end

	ao.send({
		Target = msg.From,
		Action = 'Action-Response',
		Tags = {
			Status = 'Success',
			Message = 'Collections fetched successfully'
		},
		Data = json.encode({
			Creator = creator,
			Collections = userCollections
		})
	})
end)

-- Remove collection by ID
Handlers.add('Remove-Collection', Handlers.utils.hasMatchingTag('Action', 'Remove-Collection'), function(msg)
	local collectionId = msg.Tags.CollectionId

	local collectionIndex = nil
	local collectionOwner = nil

	for index, collection in ipairs(Collections) do
		if collection.Id == collectionId then
			collectionIndex = index
			collectionOwner = collection.Creator
			break
		end
	end

	if msg.From ~= Owner and msg.From ~= ao.id and msg.From ~= collectionOwner then
		ao.send({
			Target = msg.From,
			Action = 'Authorization-Error',
			Tags = {
				Status = 'Error',
				Message = 'Unauthorized to access this handler'
			}
		})
		return
	end

	if not collectionId or collectionId == '' then
		ao.send({
			Target = msg.From,
			Action = 'Action-Response',
			Tags = {
				Status = 'Error',
				Message = 'Invalid or missing CollectionId'
			}
		})
		return
	end

	if not collectionIndex then
		ao.send({
			Target = msg.From,
			Action = 'Action-Response',
			Tags = {
				Status = 'Error',
				Message = 'Collection not found'
			}
		})
		return
	end

	table.remove(Collections, collectionIndex)
	for i, id in ipairs(CollectionsByUser[collectionOwner]) do
		if id == collectionId then
			table.remove(CollectionsByUser[collectionOwner], i)
			break
		end
	end

	Send({
		device = 'patch@1.0',
		cache = json.encode({
			Collections = Collections,
			CollectionsByUser = CollectionsByUser
		})
	})

	ao.send({
		Target = msg.From,
		Action = 'Action-Response',
		Tags = {
			Status = 'Success',
			Message = 'Collection removed successfully'
		}
	})
end)
